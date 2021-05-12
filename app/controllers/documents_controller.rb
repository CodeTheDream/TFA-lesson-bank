class DocumentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
    before_action :get_course_or_lesson
    before_action :set_document, only: [:show, :edit, :update, :destroy]
    before_action :verify_role!
  
    def index
      @documents = Document.all
    end
        
    def course_index
      @documents = @course.documents
    end

    def lesson_index
      @documents = @lesson.documents
    end

    # GET /documents/1
    # GET /documents/1.json
    def show
      # byebug
      if @course
        @document = @course.documents.build(document_params)
      elsif @lesson
        @document = @course.lesson.documents.build(document_params)
      end
    end
        
    # GET /documents/new
    def new
      @document = Document.new
      # if @document
      #   @document = @course.documents.build
      # elsif @lessson
      #   @document = @lesson.documents.build
      # end
      # byebug
      # @document = Document.new
    end
        
    # GET /documents/1/edit
    def edit
    end
        
    # POST /documents
    # POST /documents.json
    def create
      if @course
        @document = @course.documents.build(document_params)
      elsif @lesson
        @document = @lesson.documents.build(document_params)
      end
      if @document.save
        flash.notice = "The document record was created successfully."
        if @course.present?
          redirect_to course_documents_path(@course)
        elsif @lesson.present?
         redirect_to lesson_documents_path(@lesson)
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
      # if @course
      #   @document = @course.documents.build(document_params)
      # elsif @lesson
      #   @document = @lesson.documents.build(document_params)
      # end
      if @document.update(document_params)
        flash.notice = "The document record was updated successfully."
        if @course.present?
          redirect_to course_documents_path(@course)
        elsif @lesson.present?
         redirect_to lesson_documents_path(@lesson)
        else
          redirect_to "/"
        end
        # redirect_to course_documents_path(@course)
      else
        flash.now.alert = @document.errors.full_messages.to_sentence
        render :edit
      end
    end
        
    # DELETE /lessons/1
    # DELETE /lessons/1.json
    def destroy
      @document = Document.find params[:id]
      @document.destroy
      respond_to do |format|
      format.html { redirect_to "/", notice: 'Document was successfully destroyed.' }
      # format.html { redirect_to course_documents_path(@course), notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
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
      params.require(:document).permit(:name, :description, :kind, :course_id, :lesson_id, :file)
    end
  
    def catch_not_found(e)
      Rails.logger.debug("We had a not found exception.")
      flash.alert = e.to_s
      redirect_to courses_path(@course)
    end

end
