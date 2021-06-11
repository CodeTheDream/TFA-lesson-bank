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
      # create_tags(tags_params[:tag_names], @lesson)
      @lesson.tag_list=(tags_params.values)
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

  # def create_tags(tags_string, lesson)
  #   tag_names = tags_string.split(",").uniq
  #   tag_names.each do |tag_name|
  #     tag = Tag.find_by name: tag_name.downcase
  #     tag = Tag.create name: tag_name.downcase if tag.nil?
  #     hash = { tag_id: tag.id, lesson_id: lesson.id }
  #     key_word = KeyWord.find_by hash
  #     hash[:frequency] = 1
  #     key_word.present? ? (key_word.frequency += 1) : (KeyWord.create hash)
  #   end
  # end

  def tags_params
    # params.permit(:tag_names)
    params.require(:tag_names)
  end

  def get_course
    @course = Course.find(params[:course_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = @course.lessons.find(params[:id])
  end
  # def article_params
  #   params.require(:article).permit(:title, :body, :tag_list)
  # end

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

