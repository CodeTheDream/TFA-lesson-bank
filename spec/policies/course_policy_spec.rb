require 'pundit/rspec'
require 'rails_helper'
describe CoursePolicy do
  let(:policy) { described_class }
  %i(new? create? index? show?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          @user = nil
          expect(policy).not_to permit @user
          # policy.should_not permit @user
        end
      end
      context 'User is logged in' do
        it 'grants access' do
          @user = FactoryBot.create(:user)
          expect(policy).to permit @user
          # policy.should permit @user
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
          course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
          @course = Course.new(course_hash)
          expect(policy).to permit @user
        end
      end 
    end
  end
end
      
      # context 'role teacher' do
      #   before do
      #     @user = nil
      #   end
      #   it 'allow access to teacher' do
      #     @user = FactoryBot.create(:user, role:'teacher')
      #     byebug
      #     # @record&.user_id == @user.id
      #     # @user&.role == 'teacher'
      #     expect(policy).to permit @user
      #     byebug
      #   end
      # end
      # context 'owner' do
      #   # before do
      #   #   @user = nil
      #   # end
      #   it 'allow access to owner' do
      #     @user = FactoryBot.create(:user)
      #     course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      #     @record = Course.new(course_hash)
      #     # is owner
      #     # byebug
      #     @user&.id == @record.user_id
      #     # @course&.user_id == @user.id
      #     expect(policy).to permit @user
      #   end
      # end 
