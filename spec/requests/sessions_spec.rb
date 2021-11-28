require 'rails_helper'
RSpec.describe "Sessions" do
  it "signs user in and out" do
    @user = FactoryBot.create(:user)
    sign_in @user
    @user.confirm
    get root_path
    
    sign_out @user
    get root_path
  end
end