require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User' do
    before do
      @user = FactoryBot.create(:user)
    end

    after do
      @user.delete
    end

    it "is valid with valid attributes" do
      expect(@user).to be_valid 
    end

    it "is not valid without email" do
      @user.email = nil
      expect(@user).to_not be_valid
    end
  end
  describe "Associations" do
    before do
      @user = FactoryBot.create(:user)
      @courses = FactoryBot.create(:course)
    end
    after do
      @user.delete
      @courses.delete
    end
    it "has courses" do
      expect(@user.courses).to eq([@courses])
    end
  end
end
