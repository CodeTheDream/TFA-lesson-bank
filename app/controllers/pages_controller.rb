class PagesController < ApplicationController
  def landing_page
  end 

  def search
    if params[:search].blank? 
      redirect_to(root_path, alert: 'Empty field!') and return
    else
      @parameter = params[:search].downcase
      #@results = Course.all.where("title ILIKE ?", "%#{@parameter}%")
      @results = CourseSearch.new(query: params[:q], options: search_params).search
    end
  end

  def search_params
    params.permit :page, :sort_attribute, :sort_order
  end
end
