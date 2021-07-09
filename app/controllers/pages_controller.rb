class PagesController < ApplicationController
  def landing_page
  end 

  def search
    query = search_params[:search] 
    #@results = Course.all.where("title ILIKE ?", "%#{@parameter}%")
    byebug
    @results = CourseSearch.search(query: query, options: search_params)
  end

  private

  def search_params
    params.permit(:search, :page, :sort_attribute, :sort_order, :title, :description, :subject, :grade_level, :state, :district)
  end
end
