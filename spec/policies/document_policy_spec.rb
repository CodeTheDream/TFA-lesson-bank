require 'pundit/rspec'
require 'rails_helper'
describe DocumentPolicy do
  let(:policy) { described_class }

  before do
    @user = FactoryBot.create(:user)
    course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
    @course = Course.create(course_hash)
    lesson_hash = {title: "test lesson1", description: "test lesson1",
         created_at: Time.now, updated_at: Time.now, course_id: @course.id}
    @lesson = Lesson.create(lesson_hash)
    lesson_document_hash = {name: "Doc1 for RonR", description: "Doc1 for RonR", kind: "type1", created_at: "2021-06-01 03:25:33", updated_at: "2021-06-01 03:25:33",     lesson_id: @lesson.id, course_id: nil}
    @lesson_document = Document.create(lesson_document_hash)
    course_document_hash = {name: "Doc1 for RonR", description: "Doc1 for RonR", kind: "type1", created_at: "2021-06-01 03:25:33", updated_at: "2021-06-01 03:25:33",     lesson_id: nil, course_id: @course.id}
    @course_document = Document.create(course_document_hash)
  end
  
  after do
    @lesson_document.delete if @lesson_document.present?
    @course_document.delete if @course_document.present?
    @lesson.delete if @lesson.present?
    @course.delete if @course.present?
    @user.delete if @user.present?
  end
  %i(new? create? index? show? course_index? lesson_index?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          @user = nil
          expect(policy).not_to permit @user
        end
      end
      context 'User is logged in' do
        it 'grants access' do
          expect(policy).to permit @user
        end
      end
    end
  end
  %i(edit? update? destroy?).each do |ali|
    permissions ali do
      context 'owner or admin' do
        it 'denies access if it is not owner or admin' do
	  @user&.role == ''
	  @user.save
    creator_hash = { email: 'creator@creator.com', role: 'creator' }
	  @creator = User.create(creator_hash)
	  expect(policy).not_to permit @creator, @course_document
        end
      end
      context 'role admin' do
        it 'allow access to admin' do
          @user.role = "admin"
	  @user.save
          if @lesson_document.lesson_id.present?
            lesson = Lesson.find(@lesson_document.lesson_id)
            expect(policy).to permit @user, @lesson_document
          elsif
	    course = Course.find(@course_document.course_id)
            expect(policy).to permit @user, @course_document
          end
        end
      end
      context 'owner' do
        it 'allow access to admin' do
          @user.role = "admin"
	  @user.save
	  expect(policy).to permit @user, @lesson_document
        end
      end
    end
  end
end
