require 'will_paginate/array'

class PagesController < ApplicationController
  def landing_page
  end 

  def search
    @available_grade_levels = %w[Prek-K K 1 2 3 4 5 6 7 8 9 10 11 12]
    @subjects = %w[Art English Math Music Science Technology]
#    @states = %w[AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY]
    @districts = %w[ Durham Harnett Johnston Wake Warren ]
    query = search_params[:search].present? ? search_params[:search] : nil
    @selected_subject  = search_params[:subject].present? ? search_params[:subject] : ''
    @selected_district  = search_params[:district].present? ? search_params[:district] : ''
    @selected_grades = search_params[:available_grade_levels].present? ? search_params[:available_grade_levels].keys : []
    @selected_types = []
    @selected_types << "courses" if params[:courses] == "true"
    @selected_types << "lessons" if params[:lessons] == "true"
    @results = SearchItemSearch.search(query: query, options: search_params)
    if search_params[:available_grade_levels].present?
      @results =  @results.select {|x| (x.grade_level.split(' ') - (search_params[:available_grade_levels].keys)) != x.grade_level.split(' ')}
    end
    if search_params[:favorites] == "true"
      favorites = Favorite.where(user_id: current_user.id)
      results = []
      favorites.each do |favorite|
        @results.each do |result|
          results << result if (result.searchable_type == favorite.favoritable_type) && (result.searchable_id == favorite.favoritable_id)
        end
      end
      @results = results
    elsif search_params[:mycontent] == "true"
      @results = @results.select {|result| result.user_id == current_user.id}
    end
    @results = @results.paginate(page: params[:page], :per_page => 18) if @results.class == Array
  end
  private

  def search_params
    params.permit(:commit, :search, :page, :sort_attribute, :sort_order, :title, :description, :subject, :state, :district, :favorites, :mycontent, :courses, :lessons, :available_grade_levels => {} )
  end
end
