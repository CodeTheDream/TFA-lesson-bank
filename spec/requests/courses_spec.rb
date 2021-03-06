require 'rails_helper'

RSpec.describe "Courses", type: :request do
  describe "sign in" do
    it "signs user in and get the root path" do
      @user = FactoryBot.create(:user)
      sign_in @user
      get root_path
      expect(response).to redirect_to user_session_path
    end
  end

  describe "get courses_path" do
    it "renders the index view" do
      @user = FactoryBot.create(:user, role: 'admin')
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
      @course = Course.create(course_hash)
      sign_in @user
      @user.confirm
      get courses_path
      expect(response.status).to render_template(:index)
    end
  end
  describe "get course_path" do
    it "renders the :show template" do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
      @course = Course.create(course_hash)
      sign_in @user
      @user.confirm
      get course_path(id: @course.id)
      expect(response.status).to render_template(:show)
    end
    it "renders the :show template - redirects to the index path if the course id is invalid" do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
      @course = Course.new(course_hash)
      sign_in @user
      @user.confirm
      get course_path(id: 5000)
      expect(response).to redirect_to courses_path
    end
  end
  describe "get new_course_path" do
    it "renders the :new template - redirects to the index path if the the user role is invalid" do
      @user = FactoryBot.create(:user)
      @user.role = "stranger"
      Grade.create(grade_level: '1')
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
      @course = Course.new(course_hash)
      sign_in @user
      # User is not confirmed and role is stranger
      get new_course_path
      # expect(response.status).to eq(404)
      expect(response).to redirect_to user_session_path
    end
  end
  describe "get edit_course_path" do
    it "renders the :edit template" do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
      @course = Course.create(course_hash)
      sign_in @user
      @user.confirm
      get edit_course_path(id: @course.id)
      expect(response.status).to render_template(:edit)
    end
    it "renders the :edit template - redirects to the root path if the course id is invalid" do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      sign_in @user
      @user.confirm
      get course_path(id: 5000)
      expect(response).to redirect_to courses_path
    end
  end
  describe "post courses_path with valid data" do
    it "saves a new entry and redirects to the show path for the course" do
      @user = FactoryBot.create(:user)
      #check when we have the final version for tags
      # @tag = FactoryBot.create(:tag)
      # tags_string = "tag1, tag2"
      # tags_params = tags_string
      # hash = {course_id: @course.id, tag_id: @tag.id, frequency: 1}
      # KeyWord.find_or_create_by(hash)
      sign_in @user
      @user.confirm
      course_attributes = FactoryBot.attributes_for(:course)
      # create_tags(tags_params[@tag], @course)
      # create_tags(@tag, @course)
      expect { post courses_path, params: {course: course_attributes}
    }.to change(Course, :count)
      expect(response).to redirect_to course_lesson_form_courses_path(course_id: Course.last.id)
    end
  end
  describe "post courses_path with invalid data" do
    it "saves a new entry and redirects to the show path for the course" do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
      @course = Course.create(course_hash)
      #check when we have the final version for tags.  
      sign_in @user
      @user.confirm
      course_attributes = FactoryBot.attributes_for(:course)
      course_attributes.delete(:title)
      expect { post courses_path, params: {course: course_attributes}
    }.to_not change(Course, :count)
      expect(response).to redirect_to course_lesson_form_courses_path
      # course_lesson_form_courses_path
      # expect(response).to redirect_to course_lesson_form_courses_path(course_id: @course.id)

    end
  end

  describe "put course_path with valid data" do
    it "updates an entry and redirects to the edit path for the course" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
      @course = Course.create(course_hash)
      hash = { searchable_id: @course.id, searchable_type: 'Course', title: @course.title, description: @course.description, subject: @course.subject, state: @course.state, district: @course.district, grade_level: '' }
      search_item = SearchItem.create(hash)
      @course.search_item = search_item
      put course_path(id: @course.id), params: {course:{title: "React", description: "React", subject: "Hooks", 
        state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}}
      @course.reload
      expect(@course.title).to eq("React")
      expect(response).to redirect_to course_lesson_form_courses_path(course_id: @course.id)
    end
  end

  describe "put course_path with invalid data" do
    it "updates an entry and redirects to the edit path for the course" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
      @course = Course.create(course_hash)
      put course_path(id: @course.id), params: {course:{title: "", description: "", subject: "", 
        state: "", district: "", created_at: "", updated_at: "", user_id: ""}}
      @course.reload
      expect(@course.title).to_not eq("nil")
      expect(response).to redirect_to course_lesson_form_courses_path
    end
  end

  describe "delete a course record and redirects to the index path" do
    it "deletes a course record" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
      @course = Course.create(course_hash)
      expect {delete course_path(id: @course.id)}.to change(Course, :count)
      expect(response).to redirect_to courses_path
    end
  end
end
