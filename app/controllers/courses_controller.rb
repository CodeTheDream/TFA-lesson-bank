require "zip"
require 'fileutils'
class CoursesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  respond_to :html, :json
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_course, only: [:show, :edit, :update, :destroy, :download, :favorite, :unfavorite]
  before_action :verify_role!

  def index
    @courses = Course.all.includes(:grades)
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    if params[:lesson_id].present?
      @lesson = params[:lesson_id].present? ? Lesson.where(id: params[:lesson_id]).includes(:documents) : nil
      @lesson = @course.lessons[0] if ((@course.lessons.any?) && (@lesson == nil))
      @lesson = @lesson[0] if @lesson.class !=  Lesson
    else
      @lesson = nil
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
    @available_grade_levels = Grade.all
    @subjects = %w[Art English Math Music Science Technology]
    @states = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY]
    @districts = %w[ Durham Harnett Johnston Wake Warren ]
  end

  # GET /courses/1/edit
  def edit
    @available_grade_levels = Grade.all
    @subjects = %w[Art English Math Music Science Technology]
    @states = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY]
    @districts = %w[ Durham Harnett Johnston Wake Warren ]

  end

  # POST /courses
  # POST /courses.json
  def create
    @available_grade_levels = Grade.all
    @subjects = %w[Art English Math Music Science Technology]
    @states = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY]
    @districts = %w[ Durham Harnett Johnston Wake Warren ]
    @course = Course.new(course_params)
    @course.user = current_user
    @course.state = 'NC'
    @course.courses_grades.delete_all
    new_grades = grade_params[:grade_levels].present? ? Grade.where(grade_level: grade_params[:grade_levels].keys) : nil
    @course.grades << new_grades if new_grades.present?
    if @course.save
      @course.tag_list=(tags_params.values) if params[:tag_names].present?
      course_tags = @course.tags.pluck(:name).join(' ')
      hash = { searchable_id: @course.id, searchable_type: 'Course', title: @course.title, description: @course.description, subject: @course.subject, state: @course.state, district: @course.district, grade_level: @course.grades.pluck(:grade_level).join(' '), tags: course_tags, user_id: current_user.id } 
      search_item = SearchItem.create(hash)
      @course.search_item = search_item
      flash.notice = "The course record was created successfully."
      redirect_to course_lesson_form_courses_path
    else
      flash.now.alert = @course.errors.full_messages.to_sentence
      redirect_to course_lesson_form_courses_path  
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    @available_grade_levels = Grade.all
    @subjects = %w[Art English Math Music Science Technology]
    @states = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY]
    @districts = %w[ Durham Harnett Johnston Wake Warren ]
    @course.courses_grades.delete_all
    new_grades = grade_params[:grade_levels].present? ? Grade.where(grade_level: grade_params[:grade_levels].keys) : nil
    @course.grades << new_grades if new_grades.present?
    if @course.update(course_params)
      if params[:tag_names]&.present? && params[:existing_tags]&.present?
	      tags = tags_params.values + existing_tags_params
      elsif params[:tag_names]&.present?
        tags = tags_params.values
      elsif params[:existing_tags]&.present?
        tags = existing_tags_params
      end
      @course.tag_list=(tags) if tags.present?
      course_tags = @course.tags.pluck(:name).join(' ')
      hash = { searchable_id: @course.id, searchable_type: 'Course', title: @course.title, description: @course.description, subject: @course.subject, state: @course.state, district: @course.district, grade_level: @course.grades.pluck(:grade_level).join(' '), tags: course_tags, user_id: current_user.id } 
      search_item = SearchItem.find_by(searchable_id: @course.id, searchable_type: 'Course')
      search_item.update hash
      @course.search_item = search_item
      flash.notice = "The course record was updated successfully."
      redirect_to course_lesson_form_courses_path
    else
      flash.now.alert = @course.errors.full_messages.to_sentence
      redirect_to course_lesson_form_courses_path
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
    format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
    format.json { head :no_content }
    end
  end
#OLD FAVORITE FOR COURSES
  # Add and remove favorite courses
  # for current_user
  # def favorite
  #   # current_user.favorites << @course
  #   if FavoriteCourse.find_by(course_id: @course.id, user_id: current_user.id).present?
  #     redirect_to course_path(id: @course.id), notice: "You Already Favorited #{@course.title}"
  #   else
  #     current_user.favorites << @course
  #     redirect_to course_path(id: @course.id), notice: "You Favorited #{@course.title}"
  #   end
  # end
#OLD UNFAVORITE FOR COURSES
  # def unfavorite
  #   if !FavoriteCourse.find_by(course_id: @course.id, user_id: current_user.id).present?
  #     redirect_to course_path(id: @course.id), notice: "You Already Unfavorited #{@course.title}"
  #   else
  #     current_user.favorites.delete(@course)
  #     redirect_to course_path(id: @course.id), notice: "You Unfavorited #{@course.title}"
  #   end
  # end

  def favorite
    byebug
    @lesson = params[:lesson_id].present? ? Lesson.find(params[:lesson_id]) : nil
    hash = { start: true, favoritable_type: "Course", favoritable_id: @course.id, user_id: current_user.id }
    @favorite = Favorite.new(hash)
    if @favorite.save
      flash.now.alert = "Success"
      byebug
      redirect_to course_lesson_form_courses_path(@course.id)  
    else
      flash.now.alert = @course.errors.full_messages.to_sentence
      redirect_to course_lesson_form_courses_path(@course.id)  
    end
  end

  # def unfavorite
  #   byebug
  #   @unfavorite = Favorite.find_by(user_id: current_user.id, favoritable_id: @course.id)
  #   Favorite.delete(@unfavorite)
  #   # @unfavorite.destroy
  #   redirect_to course_lesson_form_courses_path(@course.id)  
  # end
  def unfavorite
    byebug
    @lesson = params[:lesson_id].present? ? Lesson.find(params[:lesson_id]) : nil
    if !Favorite.find_by(user_id: current_user.id, favoritable_id: @course.id).present?
    redirect_to course_lesson_form_courses_path(@course_id)  
    else
    @unfavorite = Favorite.find_by(user_id: current_user.id, favoritable_id: @course.id)
    Favorite.delete(@unfavorite)
    redirect_to course_lesson_form_courses_path(@course.id)  
    end
  end


  
  def download
    @courses = @course.documents.where(id: params[:document_ids].keys)
    tmp_user_folder = "tmp/course_#{@course.id}"
    begin
      FileUtils.rm_rf(tmp_user_folder)
      File.delete("#{tmp_user_folder}.zip") if File.exist?("#{tmp_user_folder}.zip")
    rescue StandarError
    end
    directory_length_same_as_documents = Dir["#{tmp_user_folder}/*"].length == @courses.length
    FileUtils.mkdir_p(tmp_user_folder) unless Dir.exists?(tmp_user_folder)
    @courses.each do |document|
      filename = document.file.blob.filename.to_s
      create_tmp_folder_and_store_documents(document, tmp_user_folder, filename) unless directory_length_same_as_documents
      #---------- Convert to .zip --------------------------------------- #
      create_zip_from_tmp_folder(tmp_user_folder, filename) unless directory_length_same_as_documents
    end
    # Sends the *.zip file to be download to the client's browser
    send_file(Rails.root.join("#{tmp_user_folder}.zip"), :type => "application/zip",
                                                         :filename => "Files_for_#{@course.title.downcase.gsub(/\s+/, "_")}.zip", :disposition => "attachment")
  end

  def course_lesson_form
    new_course = Course.new(title: "New")
    @courses = Course.where(user_id: current_user.id).to_a.unshift new_course
#    @lesson = Lesson.new
    @course = params[:course_id].present? ? Course.find(params[:course_id]) : new_course
    @available_grade_levels = Grade.all
    @subjects = %w[Art English Math Music Science Technology]
    @states = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY]
    @districts = %w[ Durham Harnett Johnston Wake Warren ]
    new_lesson = Lesson.new(title: "New")
    @lessons = @course.lessons.to_a.unshift new_lesson
    @lesson = params[:lesson_id].present? ? Lesson.find(params[:lesson_id]) : nil
    # respond_to do |format|
    #   format.html { render 'course_lesson_form'}
    #   format.js {render layout: false}
    # end
  end

  def load_course
    if ajax_params[:course_id].present?
      @course = Course.find ajax_params[:course_id]
    else
      @course = Course.new
    end
    @available_grade_levels = Grade.all
    @subjects = %w[Art English Math Music Science Technology]
    @states = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY]
    @districts = %w[ Durham Harnett Johnston Wake Warren ]
    new_lesson = Lesson.new(title: "New")
    @lessons = @course.lessons.to_a.unshift new_lesson
    @lesson = params[:lesson_id].present? ? Lesson.find(params[:lesson_id]) : nil
    @from_load_course = true
    render "/courses/course_lesson_form.js.erb"
  end

  def load_lesson
    @course = Course.find ajax_params[:course_id]
    new_lesson = Lesson.new(title: "New")
    @lessons =  @course.lessons.to_a.unshift(new_lesson) if @course.lessons.last.title != "New"
    if ajax_params[:lesson_id].present?
      @lesson = Lesson.find ajax_params[:lesson_id]
    else
      @lesson = nil 
    end
    @available_grade_levels = Grade.all
    @subjects = %w[Art English Math Music Science Technology]
    @states = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY]
    @districts = %w[ Durham Harnett Johnston Wake Warren ]
    @from_load_course = false
    render "/courses/course_lesson_form.js.erb"
  end

  private

  def create_tmp_folder_and_store_documents(document, tmp_user_folder, filename)
    File.open(File.join(tmp_user_folder, filename), "wb") do |file|
      document.file.download { |chunk| file.write(chunk) }
    end
  end

  def create_zip_from_tmp_folder(tmp_user_folder, filename)
    Zip::File.open("#{tmp_user_folder}.zip", Zip::File::CREATE) do |zf|
      zf.add(filename, "#{tmp_user_folder}/#{filename}")
    end
  end

  # def course_owner
  #   @course_owner = User.find(params[:id])    
  # end

  def verify_role!
    authorize @course || Course 
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:title, :description, :subject, :grade_level, :state, :district, :start_date, :end_date, :tag_names, :favorites)
  end

  def grade_params
    params.permit(:grade_levels => {})
  end

  def ajax_params
    params.permit(:course_id, :lesson_id)
  end

  def tags_params
    params.require(:tag_names)
  end

  def existing_tags_params
    params.require(:existing_tags)
  end

  def catch_not_found(e)
    Rails.logger.debug("We had a not found exception.")
    flash.alert = e.to_s
    redirect_to courses_path
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to root_path
  end
end
