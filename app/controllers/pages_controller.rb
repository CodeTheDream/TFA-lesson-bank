class PagesController < ApplicationController
  def landing_page
  end 

  def search
    @available_grade_levels = %w[Prek-K K 1 2 3 4 5 6 7 8 9 10 11 12]
    @subjects = %w[Art English Math Music Science Technology]
    @states = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY]
    @search = params[:search].present? ? params[:search] : nil 
    if params[:search].blank? 
      redirect_to(root_path, alert: 'Empty field!') and return
    else
      @parameter = params[:search].downcase
      @results = Course.all.where("title ILIKE ?", "%#{@parameter}%")

      filters = {}
      filters[:subject] = params[:subject] if params[:subject].present?
      filters[:grade_level] = params[:grade_level] if params[:grade_level].present?
      filters[:state] = params[:state] if params[:state].present?

      filters.keys.each do |key|
        @results = @results.reject{|x| x.grade_level != filters[:"#{key}"]} if key == :grade_level
        @results = @results.reject{|x| x.subject != filters[:"#{key}"]} if key == :subject
        @results = @results.reject{|x| x.state != filters[:"#{key}"]} if key == :state
      end
    end
  end
end
