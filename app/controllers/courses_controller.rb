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
      # create_tags(tags_params[:tag_names], @course)
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

  # def create_tags(tags_string, course)
  #   tag_names = tags_string.split(",").uniq
  #   tag_names.each do |tag_name|
  #     tag = Tag.find_by name: tag_name.downcase
  #     tag = Tag.create name: tag_name.downcase if tag.nil?
  #     hash = { tag_id: tag.id, course_id: course.id }
  #     key_word = KeyWord.find_by hash
  #     hash[:frequency] = 1
  #     key_word.present? ? (key_word.frequency += 1) : (KeyWord.create hash)
  #   end
  # end

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:title, :description, :subject, :grade_level, :state, :district, :start_date, :end_date, :tag_list)
  end

  def tags_params
    params.permit(:tag_names)
  end

  def catch_not_found(e)
    Rails.logger.debug("We had a not found exception.")
    flash.alert = e.to_s
    redirect_to courses_path
  end
end
