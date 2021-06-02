require 'rails_helper'

RSpec.describe "Courses", type: :request do
  describe "sign in" do
    it "signs user in and out" do
      @user = FactoryBot.create(:user)
      sign_in @user
      get root_path
      expect(response).to redirect_to user_session_path
    end
  end

  describe "get courses_path" do
    it "renders the index view" do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.new(course_hash)
      sign_in @user
      @user.confirm
      get courses_path
      # byebug
      expect(response.status).to render_template(:index)
    end
  end

end
