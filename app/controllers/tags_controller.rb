class TagsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def show
  end
 
  def edit
  end

  def update
    if @tag.update_attributes(tag_params)
      flash.notice = "The tag record was updated successfully."
      redirect_to courses_path
    else
      flash.now.alert = @tag.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to courses_path, notice: 'The tag was successfully deleted!'
   end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

  def catch_not_found(e)
    Rails.logger.debug("We had a not found exception.")
    flash.alert = e.to_s
    redirect_to courses_path
  end    
end


  # def tags_params
  #   params.permit(:id, :tag_names)
  # end

  # def set_lesson
  #   byebug
  #   @lesson = Lesson.find(params[:lesson_id])
  #   byebug
  # end


  # def delete
  #   tag = Tag.name.find(params[:id])
  #   tag.destroy
  #   redirect_to [@lesson.course, @lesson], notice: "The tag was deleted!"
  # end


  # Use callbacks to share common setup or constraints between actions.
  # def get_course
  #   @course = Course.find(params[:course_id])
  #   byebug
  # end

  # # Use callbacks to share common setup or constraints between actions.
  # def set_lesson
  #   @lesson = @course.lessons.find(params[:id])
  #   byebug
  # end