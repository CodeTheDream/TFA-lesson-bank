require 'rails_helper'

RSpec.describe "Lessons", type: :request do
  describe "sign in" do
    it "signs user in and get the root path" do
      @user = FactoryBot.create(:user)
      sign_in @user
      get root_path
      expect(response).to redirect_to user_session_path
    end
  end

  describe "get lessons_path" do
    it "renders the index view" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        # tags: @tag.id, ?
        created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
      # ?tags
      @lesson = Lesson.create(lesson_hash)
      get course_lessons_path(course_id: @course.id)
      expect(response.status).to render_template(:index)
    end
  end

describe "get show_assignment_path" do
  # doesn't render the :show template if a user is not logged in' ???
  it "get show_assignment_path" do
    @user = FactoryBot.create(:user)
    sign_in @user
    @user.confirm
    course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
    @course = Course.create(course_hash)
    lesson_hash = {title: "test lesson1", description: "test lesson1", 
      created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
    @lesson = Lesson.create(lesson_hash)
    get course_lesson_path(course_id: @course.id, id: @lesson.id)
    expect(response).to render_template(:show)
  end
  
  it "redirects to the courses index path if the lesson id is invalid" do
    @user = FactoryBot.create(:user)
    sign_in @user
    @user.confirm
    course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
    @course = Course.create(course_hash)
    lesson_hash = {title: "test lesson1", description: "test lesson1", 
      created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
    @lesson = Lesson.create(lesson_hash)
    get course_lesson_path(course_id: @course.id, id: 5000)
    expect(response).to redirect_to courses_path
  end
end

end
