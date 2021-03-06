require "zip"
require 'fileutils'
class CoursesController < ApplicationController
  respond_to :html, :json
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_course, only: [:show, :edit, :update, :destroy, :download, :favorite, :unfavorite, :log, :flag, :unflag]
  before_action :set_document, only: [:log]
  before_action :verify_role!

  def index
    query = search_params[:search].present? ? search_params[:search] : nil
    search_hash = {"courses" => "true", "admin_view" => "true"}
    @courses = SearchItemSearch.search(query: query, options: search_hash, current_user: current_user)
    @flags = Flag.where(flagable_type: "Course", flagable_id: @courses.pluck(:searchable_id))
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @fav_courses = Favorite.where(user_id: current_user.id, favoritable_type: "Course").distinct.pluck(:favoritable_id)
    @flagged_courses = Flag.where(flagable_type: "Course").distinct.pluck(:flagable_id)
    @fav_lessons = Favorite.where(user_id: current_user.id, favoritable_type: "Lesson").distinct.pluck(:favoritable_id)
    @flagged_lessons = Flag.where(flagable_type: "Lesson").distinct.pluck(:flagable_id)  
    if params[:lesson_id].present?
      @lesson = params[:lesson_id].present? ? Lesson.where(id: params[:lesson_id]).includes(:documents) : nil
      @lesson = @course.lessons[0] if ((@course.lessons.any?) && (@lesson == nil))
      @lesson = @lesson[0] if @lesson.class !=  Lesson
    else
      @lesson = nil
    end
    
  end

  # POST /courses
  # POST /courses.json
  def create
    @available_grade_levels = Grade.all
    @subjects = Course.subjects
    @districts = Course.districts
    @course = Course.new(course_params)
    @course.user = current_user
    @course.state = 'NC'
    @course.courses_grades.delete_all
   
    
    new_grades = grade_params[:grade_levels].present? ? Grade.where(grade_level: grade_params[:grade_levels].keys) : nil
    @course.grades << new_grades if new_grades.present?
    if @course.save
      @course.tag_list=(tags_params.values) if params[:tag_names].present?
      course_tags = @course.tags.pluck(:name).join(' ')
      hash = { searchable_id: @course.id, searchable_type: 'Course', title: @course.title, description: @course.description, subject: @course.subject, state: @course.state, district: @course.district, grade_level: @course.grades.pluck(:grade_level).join(' '), tags: course_tags, user_id: current_user.id, last_name: current_user.last_name, user_status: current_user.status } 
      search_item = SearchItem.create(hash)
      @course.search_item = search_item
      flash.notice = "The course record was created successfully."
      redirect_to course_lesson_form_courses_path(course_id: @course.id)
    else
      flash.now.alert = @course.errors.full_messages.to_sentence
      redirect_to course_lesson_form_courses_path
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    @available_grade_levels = Grade.all
    @subjects = Course.subjects
    @districts = Course.districts
    @course.courses_grades.delete_all
    new_grades = grade_params[:grade_levels].present? ? Grade.where(grade_level: grade_params[:grade_levels].keys) : nil
    @course.grades << new_grades if new_grades.present?
    if document_params[:documents].present?
      document_params[:documents].each do |document_param|
        doc = Document.find document_param[0].to_i
        doc.update document_param[1]
      end
    end
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
      hash = { searchable_id: @course.id, searchable_type: 'Course', title: @course.title, description: @course.description, subject: @course.subject, state: @course.state, district: @course.district, grade_level: @course.grades.pluck(:grade_level).join(' '), tags: course_tags, user_id: current_user.id, last_name: current_user.last_name, user_status: current_user.status } 
      search_item = SearchItem.find_by(searchable_id: @course.id, searchable_type: 'Course')
      search_item.update hash
      @course.search_item = search_item
      flash.notice = "The course record was updated successfully."
      redirect_to course_lesson_form_courses_path(course_id: @course.id)
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
  def favorite
    @lesson = params[:lesson_id].present? ? Lesson.find(params[:lesson_id]) : nil
    hash = {favoritable_type: "Course", favoritable_id: @course.id, user_id: current_user.id }
    @favorite = Favorite.new(hash)
    
    if @favorite.save
      if favorite_params[:source] == "course_edit"
        flash.now.alert = "You favorited this course"
        redirect_to course_lesson_form_courses_path(course_id: @course.id)
      elsif favorite_params[:source] == "course_show"
        flash.now.alert = "You favorited this course"
        redirect_to course_path(course_id: @course.id)
      end
    else
      if favorite_params[:source] == "course_edit"
        flash.now.alert = @course.errors.full_messages.to_sentence
        redirect_to course_lesson_form_courses_path(course_id: @course.id)
      elsif favorite_params[:source] == "course_show"
        flash.now.alert = "You favorited this course"
        redirect_to course_path(course_id: @course.id)
      end
    end
  end
  def flag
    hash = {flagable_type: "Course", flagable_id: @course.id, user_id: current_user.id, description: flag_params["flag_description"] }
    @flag = Flag.new(hash)
    @course_creator_id = @course.user_id
    @course_creator_email = @course.user.email
    if @flag.save
      flash.now.alert = "You flagged this course"
      UserMailer.with(user: @course_creator_email).send_flag_notification.deliver_now
      redirect_to course_path(course_id: @course.id)
    else
      flash.now.alert = "You flagged this course"
      redirect_to course_path(course_id: @course.id)
    end
  end
  def unfavorite
    @lesson = params[:lesson_id].present? ? Lesson.find(params[:lesson_id]) : nil
    
    if !Favorite.find_by(user_id: current_user.id, favoritable_id: @course.id).present?
      if favorite_params[:source] == "course_edit"
        redirect_to course_lesson_form_courses_path(course_id: @course.id)
      elsif favorite_params[:source] == "course_show"
        redirect_to course_path(course_id: @course.id)
      end
    else
    @unfavorite = Favorite.find_by(user_id: current_user.id, favoritable_id: @course.id, favoritable_type: "Course" )
    Favorite.destroy(@unfavorite.id)
      if favorite_params[:source] == "course_edit"
        redirect_to course_lesson_form_courses_path(course_id: @course.id)
      elsif favorite_params[:source] == "course_show"
        redirect_to course_path(course_id: @course.id)
      end
    end
  end

  def unflag
    @lesson = params[:lesson_id].present? ? Lesson.find(params[:lesson_id]) : nil
    unflag = Flag.find_by(flagable_id: @course.id, flagable_type: "Course")
    if unflag.present?
      Flag.destroy(unflag.id)
      redirect_to course_path(id: @course.id, course_id: @course.id, lesson_id: nil)
    else
      redirect_to course_path(id: @course.id, course_id: @course.id, lesson_id: nil)
    end
  end

  def log
    @document_creator = Document.find(@document.id).lesson_id.present? ? Document.find(@document.id).lesson.course.user : Document.find(@document.id).course.user
    @creator_id = @document_creator.id
    log = Log.find_or_create_by( user_id: current_user.id, document_id: @document.id, creator_id: @creator_id)
    if log.present?
      if @document.file.present?
        send_data @document.file.download, filename: @document.file.filename.to_s, content_type: @document.file.content_type
      else 
        flash.now.alert = "File could not be found"
        redirect_to course_path(course_id: @course.id)
      end
    else
      flash.now.alert = @course.errors.full_messages.to_sentence
      redirect_to course_path(course_id: @course.id)
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
    @course = params[:course_id].present? ? Course.find(params[:course_id]) : new_course
    @available_grade_levels = Grade.all
    @subjects = Course.subjects
    @districts = Course.districts
    new_lesson = Lesson.new(title: "Add Lesson")
    @lessons = @course.lessons.to_a.unshift new_lesson
    @lesson = params[:lesson_id].present? ? Lesson.find(params[:lesson_id]) : nil
    if @course&.id.present?
      @document = @course.documents.new
    elsif @lesson&.id.present?
      @document = @lesson.documents.new
    end
  end

  def load_course
    if ajax_params[:course_id].present?
      @course = Course.find ajax_params[:course_id]
    else
      @course = Course.new
    end
    @available_grade_levels = Grade.all
    @subjects = Course.subjects
    @districts = Course.districts
    new_lesson = Lesson.new(title: "Add Lesson")
    @lessons = @course.lessons.to_a.unshift new_lesson
    @lesson = params[:lesson_id].present? ? Lesson.find(params[:lesson_id]) : nil
    @from_load_course = true
    @document = @course.documents.new if @course.id.present?
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

  def set_document
    @document = Document.find(params[:document_id])
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:title, :description, :subject, :grade_level, :state, :district, :start_date, :end_date, :tag_names, :favorites, :id)
  end

  def document_params
    params.permit(:documents => {})
  end

  def favorite_params
    params.permit(:source, :id)
  end
 
  def flag_params
    params.permit(:flag_description)
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

  def search_params  
    params.permit(:commit, :search, :page, :sort_attribute, :sort_order, :title, :description, :subject, :state, :district, :favorites, :mycontent, :courses, :lessons, :selected_grades)
  end
end
