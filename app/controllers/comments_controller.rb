class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  before_action :verify_role!

  def create
    if comment_params[:course_id].present?
      @course = Course.find comment_params[:course_id]
      comment = @course.comments.new(message: comment_params[:message], user_id: current_user.id)
    elsif comment_params[:lesson_id].present?
      @lesson = Lesson.find comment_params[:lesson_id]
      comment = @lesson.comments.new(message: comment_params[:message], user_id: current_user.id)
    end
    if comment.save
      @course_comments = @course.comments.all.includes(:user) if @course.present?
      @lessons_comments = Comment.where(lesson_id: @lesson.course.lessons.pluck(:id)).includes(:user) if @lesson.present?
      render 'courses/comments.js'
    end
  end

  def destroy
    if @comment.course.present?
      @course = @comment.course
    elsif @comment.lesson.present?
      @lesson = @comment.lesson
    end
    if @comment.destroy
      @course_comments = @course.comments.all.includes(:user) if @course.present?
      @lessons_comments = Comment.where(lesson_id: @lesson.course.lessons.pluck(:id)).includes(:user) if @lesson.present?
      render 'courses/comments.js'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :message, :course_id, :lesson_id)
  end
 
  def verify_role!
    authorize @comment || Comment 
  end

  def set_comment
    @comment = Comment.find comment_params[:id]
  end
end
