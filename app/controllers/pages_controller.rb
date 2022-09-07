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
    @selected_grades = []
    if search_params[:selected_grades].present?
      @selected_grades = search_params[:selected_grades].keys
    elsif search_params[:selected_grades_back].present?
      @selected_grades = eval(search_params[:selected_grades_back])
    end
    search_hash = {}
    search_params.each do |param|
      search_hash[param[0]] = param[1]
    end
    search_hash["selected_grades"] = @selected_grades
    
    @selected_types = []
    @selected_types << "courses" if params[:courses] == "true"
    @selected_types << "lessons" if params[:lessons] == "true"
    @results = SearchItemSearch.search(query: query, options: search_hash, current_user: current_user)
  end

  private

  def search_params
    params.permit(:commit, :search, :page, :sort_attribute, :sort_order, :title, :description, :subject, :state, :district, :favorites, :mycontent, :courses, :lessons, :selected_grades_back, :selected_grades => {} )
  end
end
