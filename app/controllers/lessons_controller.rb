require "zip"
require 'fileutils'
class LessonsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  respond_to :html, :json
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :get_course
  before_action :set_lesson, only: [:show, :edit, :update, :destroy, :download]

  def index
    @lessons = @course.lessons
  end
    
  # GET /lessons/1
  # GET /lessons/1.json
  def show
  end
    
  # GET /lessons/new
  def new
    @lesson = @course.lessons.build
  end
    
  # GET /Lessons/1/edit
  def edit
  end
    
  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = @course.lessons.build(lesson_params)
    if @lesson.save
      @lesson.tag_list=(tags_params.values) if params[:tag_names].present?
      lesson_tags = @lesson.tags.pluck(:name).join(' ')    
      hash = { searchable_id: @lesson.id, searchable_type: 'Lesson', title: @lesson.title, description: @lesson.description, subject: @course.subject, state: @course.state, district: @course.district, grade_level: @course.grades.pluck(:grade_level).join(' '), tags: lesson_tags, user_id: current_user.id } 
      @lesson.search_item = SearchItem.create(hash)
      flash.notice = "The lesson record was created successfully."
      redirect_to course_lesson_form_courses_path
    else
      flash.now.alert = @lesson.errors.full_messages.to_sentence
      redirect_to course_lesson_form_courses_path
    end
  end
    
  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    if @lesson.update(lesson_params)
      if params[:tag_names]&.present? && params[:existing_tags]&.present?
	      tags = tags_params.values + existing_tags_params
      elsif params[:tag_names]&.present?
        tags = tags_params.values
      elsif params[:existing_tags]&.present?
        tags = existing_tags_params
      end
      @lesson.tag_list=(tags) if tags.present?
      lesson_tags = @lesson.tags.pluck(:name).join(' ')
      hash = { searchable_id: @lesson.id, searchable_type: 'Lesson', title: @lesson.title, description: @lesson.description, subject: @course.subject, state: @course.state, district: @course.district, grade_level: @course.grades.pluck(:grade_level).join(' '), tags: lesson_tags, user_id: current_user.id } 
      search_item = SearchItem.find_by(searchable_id: @lesson.id, searchable_type: 'Lesson')
      search_item.update(hash)
      @lesson.search_item = search_item
      flash.notice = "The lesson record was updated successfully."
      redirect_to course_lesson_form_courses_path
    else
      flash.now.alert = @lesson.errors.full_messages.to_sentence
      redirect_to course_lesson_form_courses_path
    end
  end
    
  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @lesson.destroy
    respond_to do |format|
    format.html { redirect_to course_lessons_path(@course), notice: 'Lesson was successfully destroyed.' }
    format.json { head :no_content }
    end
  end

  def favorite
    @lesson = params[:lesson_id].present? ? Lesson.find(params[:lesson_id]) : nil
    hash = { start: true, favoritable_type: "Lesson", favoritable_id: params[:lesson_id], user_id: current_user.id }
    @favorite = Favorite.new(hash)
    if @favorite.save
      flash.now.alert = "Success"
      redirect_to course_lesson_form_courses_path(@course_id)  
    else
      flash.now.alert = @course.errors.full_messages.to_sentence
      redirect_to course_lesson_form_courses_path(@course_id)  
    end
  end

  # def unfavorite
  #   @unfavorite = Favorite.find_by(user_id: current_user.id, favoritable_id: params[:lesson_id])
  #   Favorite.delete(@unfavorite)
  #   # @unfavorite.destroy
  #   redirect_to course_lesson_form_courses_path(@course_id)  
  # end
  def unfavorite
    @lesson = params[:lesson_id].present? ? Lesson.find(params[:lesson_id]) : nil
    if !Favorite.find_by(user_id: current_user.id, favoritable_id: params[:lesson_id]).present?
    redirect_to course_lesson_form_courses_path(@course_id)  
    else
    @unfavorite = Favorite.find_by(user_id: current_user.id, favoritable_id: params[:lesson_id])
    Favorite.delete(@unfavorite)
    redirect_to course_lesson_form_courses_path(@course_id)  
    end
  end

  def download
    # Lesson bulk is working
    @documents = @lesson.documents.where(id: params[:selected_documents_ids].keys)
    tmp_user_folder = "tmp/course_#{@lesson.id}"
    begin
      FileUtils.rm_rf(tmp_user_folder)
      File.delete("#{tmp_user_folder}.zip") if File.exist?("#{tmp_user_folder}.zip")
    rescue StandarError
    end
    directory_length_same_as_documents = Dir["#{tmp_user_folder}/*"].length == @documents.length
    FileUtils.mkdir_p(tmp_user_folder) unless Dir.exists?(tmp_user_folder)
    @documents.each do |document|
      filename = document.file.blob.filename.to_s
      create_tmp_folder_and_store_documents(document, tmp_user_folder, filename) unless directory_length_same_as_documents
      #---------- Convert to .zip --------------------------------------- #
      create_zip_from_tmp_folder(tmp_user_folder, filename) unless directory_length_same_as_documents
    end
    # Sends the *.zip file to be download to the client's browser
    send_file(Rails.root.join("#{tmp_user_folder}.zip"), :type => "application/zip",
                                                         :filename => "Files_for_#{@lesson.title.downcase.gsub(/\s+/, "_")}.zip", :disposition => "attachment")
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

  def tags_params
    # params.permit(:tag_names)
    params.require(:tag_names)
  end

  def existing_tags_params
    params.require(:existing_tags)
  end

  def get_course
    @course = Course.find(params[:course_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def lesson_params
    params.require(:lesson).permit(:title, :description, :course_id, :tag_names)
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
