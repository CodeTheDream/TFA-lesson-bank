class DocumentsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  respond_to :html, :json
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :get_course_or_lesson
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :verify_role!
  
#  def index
#    @documents = Document.all
#  end
#      
#  def course_index
#    @documents = @course.documents
#  end
#
#  def lesson_index
#    @documents = @lesson.documents
#  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    respond_to do |format|
      format.html { render }
      format.zip { send_zip @document.file }
    end
    @document = Document.find params[:id]

    # if @course
    #   @document = @course.documents.build(document_params)
    # elsif @lesson

      # @document = @course.lesson.documents.build(document_params)
    #end
  end
      
#  # GET /documents/new
#  def new
#    @document = Document.new
#  end
      
#  # GET /documents/1/edit
#  def edit
#  end
      
  # POST /documents
  # POST /documents.json
  def create
    if @course
      @document = @course.documents.build(document_params)
    elsif @lesson
      @document = @lesson.documents.build(document_params)
    elsif params[:lesson_id].present?
      @lesson = Lesson.find params[:lesson_id]
      @document = @lesson.documents.build(document_params)
    end
    if @document.save
      flash.notice = "The document record was created successfully."
      if @course.present?
        redirect_to course_lesson_form_courses_path(course_id: @course.id)
      elsif @lesson.present?
        redirect_to course_lesson_form_courses_path(course_id: @lesson.course.id)
      else
        redirect_to "/"
      end
    else
      flash.now.alert = @document.errors.full_messages.to_sentence
      render :new  
    end
  end
  
  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update    
  end
      
  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @document = Document.find params[:id]
    @course = Course.find params[:course_id] if params[:course_id].present?
    if @document.destroy
      flash.notice = "The document record was deleted successfully."
      if @course.present?
        redirect_to course_lesson_form_courses_path(course_id: @course.id)
      elsif @lesson.present?
        redirect_to "/courses/course_lesson_form?course_id=#{@lesson.course.id}&lesson_id=#{@lesson.id}#lesson#{@lesson.id}"   
      else
        redirect_to "/"
      end
    else
      flash.notice = "This document could not be deleted."
      redirect_to "/"
    end
  end
      
  private
  
  def verify_role!
    authorize @document || Document 
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def get_course_or_lesson
    if params[:course_id].present?
      @course = Course.find(params[:course_id])
    elsif params[:lesson_id]
      @lesson = Lesson.find params[:lesson_id]
    end
  end

  def set_document
    @document = Document.find(params[:id])
  end
      
  # Only allow a list of trusted parameters through.
  def document_params
    params.require(:document).permit(:name, :description, :kind, :course_id, :lesson_id, :file, :id)
  end
  
  def catch_not_found(e)
    Rails.logger.debug("We had a not found exception.")
    flash.alert = e.to_s
    redirect_to courses_path(@course)
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to root_path
  end
end
