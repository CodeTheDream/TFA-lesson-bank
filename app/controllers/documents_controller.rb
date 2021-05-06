class DocumentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
    before_action :set_document, only: [:show, :edit, :update, :destroy]
    before_action :verify_role!
  
    def index
      @documents = Document.all
    end
        
    # GET /documents/1
    # GET /documents/1.json
    def show
    end
        
    # GET /documents/new
    def new
      @document = Document.new
    end
        
    # GET /documents/1/edit
    def edit
    end
        
    # POST /documents
    # POST /documents.json
    def create
      @document = Document.new(document_params)
      if @document.save
        flash.notice = "The document record was created successfully."
        redirect_to documents_path
      else
        flash.now.alert = @document.errors.full_messages.to_sentence
        render :new  
      end
    end
    
    # PATCH/PUT /documents/1
    # PATCH/PUT /documents/1.json
    def update
      if @document.update(document_params)
        flash.notice = "The document record was updated successfully."
        redirect_to @document
      else
        flash.now.alert = @document.errors.full_messages.to_sentence
        render :edit
      end
    end
        
    # DELETE /lessons/1
    # DELETE /lessons/1.json
    def destroy
      @document.destroy
      respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
      end
    end
        
    private
    
    def verify_role!
      authorize @document || Document 
    end
    
    # Use callbacks to share common setup or constraints between actions.
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
      redirect_to documents_path
    end

end
