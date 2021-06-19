class CoursesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :verify_role!

  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    @course.user = current_user
    if @course.save
      @course.tag_list=(tags_params.values) if params[:tag_names].present?
      flash.notice = "The course record was created successfully."
      redirect_to courses_path
    else
      flash.now.alert = @course.errors.full_messages.to_sentence
      render :new  
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    if @course.update(course_params)
      if params[:tag_names]&.present? && params[:existing_tags]&.present?
	      tags = tags_params.values + existing_tags_params
      elsif params[:tag_names]&.present?
        tags = tags_params.values
      elsif params[:existing_tags]&.present?
        tags = existing_tags_params
      end
      @course.tag_list=(tags) if tags.present?
      flash.notice = "The course record was updated successfully."
      redirect_to @course
    else
      flash.now.alert = @course.errors.full_messages.to_sentence
      render :edit
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @course.destroy
    respond_to do |format|
    format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
    format.json { head :no_content }
    end
  end

  private

  def verify_role!
    authorize @course || Course 
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:title, :description, :subject, :grade_level, :state, :district, :start_date, :end_date, :tag_names)
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
end
