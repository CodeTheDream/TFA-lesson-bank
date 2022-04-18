require 'pundit/rspec'
require 'rails_helper'
describe LessonPolicy do
  let(:policy) { described_class }
  # before do
  #   @user = FactoryBot.create(:user)
  #   course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
  #   @course = Course.create(course_hash)
  #   lesson_hash = {title: "test lesson1", description: "test lesson1",
  #        created_at: Time.now, updated_at: Time.now, course_id: @course.id}
  #   @lesson = Lesson.create(lesson_hash)
  #   @lesson_owner = Lesson.find(@lesson.id).course.user
  #   @course_owner = Course.find(@course.id).user
  # end
  
  # after do
  #   @course_owner.delete if @course_owner.present?
  #   @lesson_owner.delete if @lesson_owner.present?
  #   @lesson.delete if @lesson.present?
  #   @course.delete if @course.present?
  #   @user.delete if @user.present?
  # end
  # new? create? index? 
  %i(index? unflag?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          @user = nil
          expect(policy).not_to permit @user
        end
      end
      context 'User is logged in' do
        it 'as user it denies access as only admins will see index view' do
          @user = FactoryBot.create(:user, role:'user')
          @user.save
          expect(policy).not_to permit @user
        end
        it 'as creator it denies access as only admins will see index view' do
          @user = FactoryBot.create(:user, role:'creator')
          @user.save
          expect(policy).not_to permit @user
        end
        it 'as admin it grants access' do
          @user = FactoryBot.create(:user, role:'admin')
          @user.save
          expect(policy).to permit @user
        end
        
      end  
    end
  end
  %i(new? create?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          @user = nil
          expect(policy).not_to permit @user
        end
      end
      context 'User is logged in' do
        it 'as user it denies access to create and new' do
          @user = FactoryBot.create(:user, role:'user')
          @user.save
          expect(policy).not_to permit @user
        end
        it 'as creator it grants access to create and new' do
          @user = FactoryBot.create(:user)
          @user.save
          expect(policy).to permit @user
        end
        it 'as admin it grants access to to create and new' do
          @user = FactoryBot.create(:user, role:'admin')
          @user.save
          expect(policy).to permit @user
        end
      end  
    end
  end
  %i(favorite? flag? unfavorite? download?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          @user = nil
          expect(policy).not_to permit @user
        end
      end
      context 'User is logged in' do
        it 'as user it grants access' do
          @user = FactoryBot.create(:user, role:'user')
          @user.save
          expect(policy).to permit @user
        end
      end
    end
  end
  %i(update? destroy?).each do |ali|
    permissions ali do
      context 'owner or admin' do
        it 'denies access if it is not owner or admin' do
          @user = FactoryBot.create(:user)
          @user&.role == ''
          expect(policy).not_to permit @user
        end
      end
      context 'role admin' do
        it 'denies access to edit content to admin for copywright issues' do
          @user = FactoryBot.create(:user, role:'admin')
          @user.save
          expect(policy).not_to permit @user
        end
      end 
      context 'owner' do
        it 'allow access to owner and creator' do
          @user = FactoryBot.create(:user, role:'creator')
          course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
          @course = Course.new(course_hash)
          @course.save
          lesson_hash = {title: "test lesson1", description: "test lesson1", 
            created_at: Time.now, updated_at: Time.now, course_id: @course.id}
          @lesson = Lesson.create(lesson_hash)
          byebug
          @creator = @lesson.present? ? Lesson.find(@lesson.id).course.user : Course.find(@course.id).user
          @lesson.save
          @user.save
          @creator.save
          byebug
          @user.id == @creator.id
          expect(policy).to permit @user
        end
      end 
    end
  end
end

