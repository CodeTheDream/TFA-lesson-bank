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
  describe "get new_course_lesson_path" do
    it "renders the :new template" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
      get new_course_lesson_path(course_id: @course.id, id: @lesson.id),
        params: {lesson: {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id}}
      expect(response).to render_template(:new)
    end
    it "redirects to the new_user_session_path if a user is not confirm" do
      @user = FactoryBot.create(:user)
      sign_in @user
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
      get new_course_lesson_path(course_id: @course.id, id: @lesson.id),
        params: {lesson: {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id}}
      #response 300 checkit
      expect(response).to redirect_to new_user_session_path
    end
  end
  describe "get edit_course_lesson_path" do
    it "renders the :edit template" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
      get edit_course_lesson_path(course_id: @course.id, id: @lesson.id),
        params: {lesson: {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id}}
      expect(response.status).to eq(200)
      expect(response).to render_template(:edit)
    end
  end

  describe "post lessons_path with valid data" do
    it "saves a new entry and redirects to the show path for the lessons" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
     expect { post course_lessons_path(course_id: @course.id, id: @lesson.id), 
          params: {lesson: {title: "test lesson1", description: "test lesson1", 
            created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}}
        }.to change(@course.lessons, :count)      
      end
    end
    describe "post lessons_path with invalid data" do
    it "doesn't save a new entry and render an edit template for the" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
     expect { post course_lessons_path(course_id: 0, id: @lesson.id), 
          params: {lesson: {title: "test lesson1", description: "test lesson1", 
            created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: 0}}
        }.not_to change(@course.lessons, :count)
        #check redirect here
        # expect(response).to redirect_to new_course_lesson_path(@course_id)
        # redirect_to new_course_lesson_path(@course_id)     
      end
    end
    describe "put course_lesson_path with valid data" do
      it "updates an entry and redirects to the show path for the lesson" do
        @user = FactoryBot.create(:user)
        sign_in @user
        @user.confirm
        course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
        @course = Course.create(course_hash)
        lesson_hash = {title: "test lesson1", description: "test lesson1", 
          created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
        @lesson = Lesson.create(lesson_hash)
        put course_lesson_path(course_id: @course.id, id: @lesson.id), 
        params: {lesson: {title: "test lesson1", description: "test lesson1", 
          created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}}
        @lesson.reload  
        expect(@lesson.course_id).to eq(@course.id) 
        expect(@lesson.id).to eq(@lesson.id)   
        expect(@lesson.description).to eq("test lesson1") 
      expect(response).to redirect_to [@course, @lesson]
      end
    end
  describe "put course_lesson_path with valid data" do
    it "does not update an entry and render an edit template for the course_lesson_path" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
      put course_lesson_path(course_id: 0, id: 0), 
      params: {lesson: {title: "test lesson1", description: "", 
        created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: 0}}
      @lesson.reload  
      expect(@lesson.course_id).not_to eq(0)    
      expect(@lesson.id).not_to eq(0)   
      expect(@lesson.description).not_to eq("") 
    #checkthe render
    # expect(response).to render_template(:edit)
    end
  end  

  describe "delete a course_lesson record" do
    it "deletes a course_lesson and redirects to the course index path" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
      @course = @lesson.course
      expect{ delete course_lesson_path(@course, @lesson)}.to change(@course.lessons, :count)
      expect(response).to redirect_to course_lessons_path(@course) 
    end
  end
end