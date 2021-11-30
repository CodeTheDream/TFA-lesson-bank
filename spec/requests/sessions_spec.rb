require 'rails_helper'
RSpec.describe "Sessions" do
  it "signs user in and out" do
    @user = FactoryBot.create(:user)
    sign_in @user
    @user.confirm
    get root_path
    expect(response.status).to eq(200)
    sign_out @user
    get root_path
    expect(response.status).to eq(200)
  end
  it "won't sign user in because user (role stranger) and user is not confirmed" do
    # User is not confirmed and role is stranger
    userstranger = {email: 'test@test.com', role: 'stranger', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
    @user = User.create(userstranger)
    sign_in @user
    get users_path
    expect(response.status).to eq(302)
    expect(response).to redirect_to user_session_path
  end
end