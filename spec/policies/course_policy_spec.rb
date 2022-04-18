require 'pundit/rspec'
require 'rails_helper'
describe CoursePolicy do
  let(:policy) { described_class }
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
          expect(policy).not_to permit @user
        end
        it 'as creator it denies access as only admins will see index view' do
          @user = FactoryBot.create(:user, role:'creator')
          expect(policy).not_to permit @user
        end
        it 'as admin it grants access' do
          @user = FactoryBot.create(:user, role:'admin')
          expect(policy).to permit @user
        end
        
      end  
    end
  end
  %i(show? favorite? flag? unfavorite? log? download?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          @user = nil
          expect(policy).not_to permit @user
        end
      end
      context 'User is logged in' do
        it 'as user it grants access' do
          @user = FactoryBot.create(:user,role:'user')
          expect(policy).to permit @user
        end
        it 'as creator it grants access' do
          @user = FactoryBot.create(:user)
          expect(policy).to permit @user
        end
        it 'as admin it grants access' do
          @user = FactoryBot.create(:user, role:'admin')
          expect(policy).to permit @user
        end
      end  
    end
  end
  %i(edit? update? destroy?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          @user = nil
          expect(policy).not_to permit @user
        end
      end
      context 'User is logged in' do
        context 'role empty' do
          it 'denies access if it is not owner or admin' do
            @user = FactoryBot.create(:user)
            @user&.role == ''
            expect(policy).not_to permit @user
          end
        end
        context 'role admin' do
          it 'denies access to edit content to admin for copywright issues' do
            @user = FactoryBot.create(:user, role:'admin')
            # byebug
            expect(policy).not_to permit @user
          end
        end 
        # context 'owner' do
        #   it 'allow access to creator and owner' do
        #     @user = FactoryBot.create(:user, role:'creator')
        #     course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
        #     @course = Course.new(course_hash)
        #     expect(policy).to permit @user
        #   end
        # end 
      end
    end
  end
end
