require 'pundit/rspec'
require 'rails_helper'
describe LessonPolicy do
  let(:policy) { described_class }
  %i(new? create? index? show?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          @user = nil
          expect(policy).not_to permit @user
        end
      end
      context 'User is logged in' do
        it 'grants access' do
          @user = FactoryBot.create(:user)
          expect(policy).to permit @user
        end
      end  
    end
  end
   
  %i(edit? update? destroy?).each do |ali|
    permissions ali do
      context 'owner or admin' do
        it 'denies access if it is not owner or admin' do
          @user = FactoryBot.create(:user)
          @user&.role == ''
          expect(policy).not_to permit @user
        end
      end
      context 'role admin' do
        it 'allow access to admin' do
          @user = FactoryBot.create(:user, role:'admin')
          expect(policy).to permit @user
        end
      end 
      context 'owner' do
        it 'allow access to admin' do
          @user = FactoryBot.create(:user, role:'admin')
          course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
          @course = Course.new(course_hash)
          lesson_hash = {title: "test lesson1", description: "test lesson1", 
            created_at: Time.now, updated_at: Time.now, course_id: @course.id}
          @lesson = Lesson.create(lesson_hash)
          expect(policy).to permit @user
        end
      end 
    end
  end
end
