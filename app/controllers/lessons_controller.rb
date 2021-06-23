class LessonsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  # layout 'lesson_layout'
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  def index
    @lessons = Lesson.all
  end
    
  # GET /lessons/1
  # GET /lessons/1.json
  def show
  end
    
  # GET /lessons/new
  def new
    @lesson = Lesson.new
  end
    
  # GET /Lessons/1/edit
  def edit
  end
    
  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.save
      flash.notice = "The lesson record was created successfully."
      redirect_to @lesson
    else
      flash.now.alert = @lesson.errors.full_messages.to_sentence
      render :new  
    end
  end
    
  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    if @lesson.update(lesson_params)
      flash.notice = "The lesson record was updated successfully."
      redirect_to @lesson
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
    format.html { redirect_to lessons_url, notice: 'Lesson was successfully destroyed.' }
    format.json { head :no_content }
    end
  end
    
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end
    
  # Only allow a list of trusted parameters through.
  def lesson_params
    params.require(:lesson).permit(:title, :description, :course_id, :units_covered, :tags)
  end
  def catch_not_found(e)
    Rails.logger.debug("We had a not found exception.")
    flash.alert = e.to_s
    redirect_to lessons_path
  end
end

