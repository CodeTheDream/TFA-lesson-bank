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
    @selected_subject  = search_params[:subject].present? ? search_params[:subject] : ''
    @results = SearchItemSearch.search(query: query, options: search_params)
    if search_params[:favorites] == "true"
      results_id = @results.pluck :id
      favorites = FavoriteCourse.where(user_id: current_user.id).distinct.pluck :course_id
      @results = @results.select {|result| ((favorites.include? result.searchable_id) && (result.searchable_type == "Course"))}
    # end
    elsif search_params[:mycontent] == "true"
      @results = @results.select {|result| result.user_id == current_user.id}
    end
  end
  private

  def search_params
    params.permit(:commit, :search, :page, :sort_attribute, :sort_order, :title, :description, :subject, :grade_level, :state, :district, :favorites, :mycontent)
  end
end
