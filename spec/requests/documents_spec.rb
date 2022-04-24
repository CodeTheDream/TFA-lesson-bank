require 'rails_helper'

RSpec.describe "Documents", type: :request do
  describe "sign in" do
    it "signs user in and get the root path" do
      @user = FactoryBot.create(:user)
      sign_in @user
      get root_path
      expect(response).to redirect_to user_session_path
    end
  end
  describe "post documents with valid data" do
    it "saves a new entry and redirects to the course_lesson_form_courses_path" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
      document_hash = {name: "Doc1 for RonR", description: "Doc1 for RonR", kind: "type1", created_at: "2021-06-01 03:25:33", updated_at: "2021-06-01 03:25:33", lesson_id: @lesson.id, course_id: @course.id}
      @document = Document.create(document_hash)
      expect { post documents_path, params: {document: document_hash}
    }.to change(Document, :count)
      document_obj = OpenStruct.new(document_attributes)
      expect(response).to redirect_to course_lesson_form_courses_path(course_id: course_obj.id)
    end
  end

end

# describe "get course_index_course_documents_path" do
#   it "renders the course_index view" do
#     @user = FactoryBot.create(:user)
#     sign_in @user
#     @user.confirm
#     course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
#     @course = Course.create(course_hash)
#     lesson_hash = {title: "test lesson1", description: "test lesson1", 
#       created_at: Time.now, updated_at: Time.now, course_id: @course.id}
#     @lesson = Lesson.create(lesson_hash)
#     document_hash = {name: "Doc1 for RonR", description: "Doc1 for RonR", kind: "type1", created_at: "2021-06-01 03:25:33", updated_at: "2021-06-01 03:25:33", lesson_id: @lesson.id, course_id: @course.id}
#     @document = Document.create(document_hash)
#     get course_index_course_documents_path(course_id: @course.id)
#     expect(response.status).to redirect_to ourse_index_course_documents_path
#   end
# end
# describe "get lesson_index_lesson_documents_path" do
#   it "renders the course_index view" do
#     @user = FactoryBot.create(:user)
#     sign_in @user
#     @user.confirm
#     course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
#     @course = Course.create(course_hash)
#     lesson_hash = {title: "test lesson1", description: "test lesson1", 
#       created_at: Time.now, updated_at: Time.now, course_id: @course.id}
#     @lesson = Lesson.create(lesson_hash)
#     document_hash = {name: "Doc1 for RonR", description: "Doc1 for RonR", kind: "type1", created_at: "2021-06-01 03:25:33", updated_at: "2021-06-01 03:25:33", lesson_id: @lesson.id, course_id: @course.id}
#     @document = Document.create(document_hash)
#     get lesson_index_lesson_documents_path(lesson_id: @lesson.id)
#     expect(response.status).to render_template(:lesson_index)
#   end
# end

