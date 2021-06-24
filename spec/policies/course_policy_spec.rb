require 'pundit/rspec'
require 'rails_helper'
describe CoursePolicy do
  let(:policy) { described_class }
  %i(new? create?).each do |ali|
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
end