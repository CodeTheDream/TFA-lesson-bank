class PagesController < ApplicationController
  def landing_page
  end 

  def search
    if params[:search].blank? 
      redirect_to(root_path, alert: 'Empty field!') and return
    else
      @parameter = params[:search].downcase
      @results = Course.all.where("title ILIKE ?", "%#{@parameter}%")
    end
  end
end
