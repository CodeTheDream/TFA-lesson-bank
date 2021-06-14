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
      @course = Course.create(course_hash)
      sign_in @user
      @user.confirm
      get courses_path
      # byebug
      expect(response.status).to render_template(:index)
    end
  end
  describe "get course_path" do
    it "renders the :show template" do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      sign_in @user
      @user.confirm
      get course_path(id: @course.id)
      expect(response.status).to render_template(:show)
    end
    it "renders the :show template - redirects to the index path if the customer id is invalid" do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.new(course_hash)
      sign_in @user
      @user.confirm
      get course_path(id: 5000)
      expect(response).to redirect_to courses_path
    end
  end
  describe "get new_customer_path" do
    it "renders the :new template - redirects to the index path if the the user role is invalid" do
      @user = FactoryBot.create(:user)
      @user.role = "stranger"
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.new(course_hash)
      sign_in @user
      # User is not confirmed and role is tranger
      get new_course_path
      # expect(response.status).to eq(404)
      expect(response).to redirect_to user_session_path
    end
  end
  describe "get edit_course_path" do
    it "renders the :edit template" do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      sign_in @user
      @user.confirm
      get edit_course_path(id: @course.id)
      expect(response.status).to render_template(:edit)
    end
    it "renders the :edit template - redirects to the root path if the course id is invalid" do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      sign_in @user
      @user.confirm
      get course_path(id: 5000)
      expect(response).to redirect_to courses_path
    end
  end
  describe "post courses_path with valid data" do
    it "saves a new entry and redirects to the show path for the course" do
      # @user = FactoryBot.create(:user)
      # course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      # @course = Course.create(course_hash)
      # sign_in @user
      # @user.confirm
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag)
      tags_string = "tag1, tag2"
      tags_params = tags_string
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      hash = {course_id: @course.id, tag_id: @tag.id, frequency: 1}
      KeyWord.find_or_create_by(hash)
      sign_in @user
      @user.confirm
      # tag_names = tags_string.split(",").uniq
      course_attributes = FactoryBot.attributes_for(:course)
      # create_tags(tags_params[@tag], @course)
      # create_tags(@tag, @course)

      expect { post courses_path, params: {course: course_attributes}

    }.to change(Course, :count)
      expect(response).to redirect_to course_path(id: Course.last.id)
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
