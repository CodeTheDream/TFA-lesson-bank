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
    # byebug
    if search_params[:favorites] == "true"
      # byebug
      # allowed_pages = policy_scope(Pages)
      # byebug
      results_id = @results.pluck :id
      byebug
      # CHUCK FAVORITES
      # favorites = FavoriteCourse.where(user_id: current_user.id, course_id: results_id).pluck :course_id
      favorites = FavoriteCourse.where(user_id: current_user.id).distinct.pluck :course_id
      byebug
      # favorites = FavoriteCourse.where(user_id: current_user.id, course_id: results_id).pluck :course_id
      # RESULTS CHUCK
      # @results = @results.select {|result| favorites.include? (result.id)}
      # MIO
      @results = @results.select {|result| ((favorites.include? result.searchable_id) && (result.searchable_type == "Course"))}
      # @results = @results.select {|result| result['course_id'] == (favorites)}
#       res = @results.select { |result| favorites.include? (result.course_id)}
#       res = @results.select { |result| @results.id == favorites }
# *** NoMethodError Exception: undefined method `id' for #<Searchkick::Results:0x00007fdaa5b38968>

      # OTRO
      # @results.select { |result| result['course_id'] != "" } ok
      # @results.select { |result| result['course_id'] == "3" } ok
      # @results = @results.select {|result| favorites.include? (result.id)}
      byebug
    end
  end

  private

  def search_params
    params.permit(:commit, :search, :page, :sort_attribute, :sort_order, :title, :description, :subject, :grade_level, :state, :district, :favorites)
  end
end
