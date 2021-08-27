class TagsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new tag_params
    if @tag.save
      redirect_to tags_path, notice: 'Tag was successfully created.'
    else
      redirect_to tags_path, notice: 'Tag was not successfully created.'
    end
  end    
      
  def edit
  end

  def update
    if @tag.update tag_params
      redirect_to tags_path, notice: 'Tag was successfully updated.'
    else
      redirect_to tags_path, notice: 'Tag was not successfully updated.'
    end
  end

  def show
  end
  
  # def show
  #   if params[:name].present?
  #     @tag = Tag.find params[:id]
  #   end
  # end



  def destroy
    if @tag.destroy
      redirect_to tags_path, notice: 'Tag was successfully deleted.'
    else
      redirect_to tags_path, notice: 'Tag was not successfully deleted.'
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end
end
