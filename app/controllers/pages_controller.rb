class PagesController < ApplicationController
  def landing_page
  end 

  def search
    @available_grade_levels = %w[Prek-K K 1 2 3 4 5 6 7 8 9 10 11 12]
    @subjects = %w[Art English Math Music Science Technology]
#    @states = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY]
    @districts = %w[ Durham Harnett Johnston Wake Warren ]
    @search = search_params[:search].present? ? search_params[:search] : nil
    query = @search
    @results = SearchItemSearch.search(query: query, options: search_params)
  
    # @tags_hash = cards_tags(@results)
  end
  
  private

  # def cards_tags(results) 
  #   tags_hash = {} 
  #   byebug   
  #   results.each do |result|
  #     byebug
  #     if result.tags.any?
  #       tags_hash[result] = result.tags.pluck :names
  #     end
  #   end
  # end

  def search_params
    params.permit(:commit, :search, :page, :sort_attribute, :sort_order, :title, :description, :subject, :grade_level, :state, :district, :tag_names)
  end
end
