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
    @search = query
    @selected_subject  = search_params[:subject].present? ? search_params[:subject] : ''
    @selected_district  = search_params[:district].present? ? search_params[:district] : ''
    @selected_grades = nil
    if search_params[:selected_grades].present?
      @selected_grades = search_params[:selected_grades].keys 
    elsif search_params[:selected_grades_back].present?
      @selected_grades = eval(search_params[:selected_grades_back])
    end
      
    
    @selected_types = []
    @selected_types << "courses" if params[:courses] == "true"
    @selected_types << "lessons" if params[:lessons] == "true"
    @results = SearchItemSearch.search(query: query, options: search_params, current_user: current_user)

    if @selected_grades.present?
      @results =  @results.select {|x| (x.grade_level.split(' ') - (@selected_grades)) != x.grade_level.split(' ')}
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
    end
    @results = @results.paginate(page: params[:page], :per_page => 18) if @results.class == Array
  end
  private

  def search_params
    params.permit(:commit, :search, :page, :sort_attribute, :sort_order, :title, :description, :subject, :state, :district, :favorites, :mycontent, :courses, :lessons, :selected_grades_back, :selected_grades => {} )
  end
end
