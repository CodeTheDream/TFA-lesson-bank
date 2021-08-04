class LessonsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :get_course
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

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
      hash = { searchable_id: @lesson.id, searchable_type: 'Lesson', title: @lesson.title, description: @lesson.description, units_covered: @lesson.units_covered, course_id: @lesson.course_id } 
      @lesson.search_item = SearchItem.create(hash)
      flash.notice = "The lesson record was created successfully."
      redirect_to [@course, @lesson]#course_lessons_path(@lesson)
    else
      flash.now.alert = @lesson.errors.full_messages.to_sentence
      render :new  
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
      hash = { searchable_id: @lesson.id, searchable_type: 'Lesson', title: @lesson.title, description: @lesson.description, units_covered: @lesson.units_covered, course_id: @lesson.course_id } 
      search_item = SearchItem.find_by(searchable_id: @lesson.id, searchable_type: 'Lesson')
      search_item.update(hash)
      @lesson.search_item = search_item
      flash.notice = "The lesson record was updated successfully."
      redirect_to [@course, @lesson]#course_lessons_path(@course)
    else
      flash.now.alert = @lesson.errors.full_messages.to_sentence
      render :edit
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
    
  private

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
    params.require(:lesson).permit(:title, :description, :course_id, :units_covered, :tag_names)
  end

  def catch_not_found(e)
    Rails.logger.debug("We had a not found exception.")
    flash.alert = e.to_s
    redirect_to courses_path
  end
end

