require 'pundit/rspec'
require 'rails_helper'
describe LessonPolicy do
  let(:policy) { described_class }
  before do
    @user = FactoryBot.create(:user, role: "user")
    @creator = FactoryBot.create(:user)
    @admin = FactoryBot.create(:user, role: "admin")
    creator_course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @creator.id}
    admin_course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @admin.id}
    @creator_course = Course.create(creator_course_hash)
    @admin_course = Course.create(admin_course_hash)
    creator_lesson_hash = {title: "test lesson1", description: "test lesson1", created_at: Time.now, updated_at: Time.now, course_id: @creator_course.id}
    admin_lesson_hash = {title: "test lesson1", description: "test lesson1", created_at: Time.now, updated_at: Time.now, course_id: @admin_course.id}
    @creator_lesson = Lesson.create(creator_lesson_hash)
    @admin_lesson = Lesson.create(admin_lesson_hash)
  end
  
  after do
    @creator_lesson.delete if @creator_lesson.present?
    @admin_lesson.delete if @admin_lesson.present?
    @creator_course.delete if @creator_course.present?
    @admin_course.delete if @admin_course.present?
    @user.delete if @user.present?
    @creator.delete if @creator.present?
    @admin.delete if @admin.present?
  end
  
  %i(index? unflag?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          @user = nil
          expect(policy).not_to permit @user, Lesson
        end
      end
      context 'User is logged in' do
        it 'as user it denies access as only admins will see index view' do
          expect(policy).not_to permit @user, Lesson
        end
        it 'as creator it denies access as only admins will see index view' do
          expect(policy).not_to permit @creator, Lesson
        end
        it 'as admin it grants access' do
          expect(policy).to permit @admin, Lesson
        end
      end  
    end
  end
  %i(new? create?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          user = nil
          expect(policy).not_to permit user, Lesson
        end
      end
      context 'User is logged in' do
        it 'as user it denies access to create and new' do
          expect(policy).not_to permit @user, Lesson
        end
        it 'as creator it grants access to create and new' do
          expect(policy).to permit @creator, Lesson
        end
        it 'as admin it grants access to to create and new' do
          expect(policy).to permit @admin, Lesson
        end
      end  
    end
  end
  %i(favorite? flag? unfavorite? download?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          @user = nil
          expect(policy).not_to permit @user, @creator_lesson
        end
      end
      context 'User is logged in' do
        it 'as user it grants access' do
          expect(policy).to permit @creator, @creator_lesson
          expect(policy).to permit @admin, @admin_lesson
        end
      end
    end
  end
  %i(update? destroy?).each do |ali|
    permissions ali do
      context 'owner or admin' do
        it 'denies access if it is not owner or admin' do
          expect(policy).not_to permit @user, @creator_lesson
          expect(policy).not_to permit @creator, @admin_lesson
        end
      end
      context 'role admin' do
        it 'denies access to edit content to admin for copywright issues' do
          expect(policy).not_to permit @admin, @creator_lesson
        end
      end 
      context 'owner' do
        it 'allow access to owner and creator' do
          expect(policy).to permit @admin, @admin_lesson
          expect(policy).to permit @creator, @creator_lesson
        end
      end 
    end
  end
end

