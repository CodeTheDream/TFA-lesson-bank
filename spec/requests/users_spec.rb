require 'rails_helper'
RSpec.describe "Users", type: :request do  
  describe "sign in" do
    it "signs user in and get the root path" do
      @user = FactoryBot.create(:user)
      sign_in @user
      get root_path
      expect(response).to redirect_to user_session_path
    end
  end
  describe "sign out" do
    it "signs user out" do
      @user = FactoryBot.create(:user)      
      sign_in @user
      sign_out @user
      get user_edit_path(id: @user.id)
      expect(response).to redirect_to new_user_session_path
    end
  end
  describe "get user_index_path" do
    it "renders the :index template if your user is sign_in and your status is Approved" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      get users_path
      expect(response.status).to render_template(:index)
      redirect_to users_path
    end
    it "it won't render the :index template if your user is sign_in, but your user status is Pending" do
      userpending = {email: 'test@test.com', role: 'teacher', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(userpending)
      sign_in @user
      @user.confirm
      get users_path
      expect(response.status).not_to render_template(:index)
      redirect_to root_path
    end
    it "it won't render the :index template if your user is not sign_in (user status is Approved)" do
      @user = FactoryBot.create(:user)
      get users_path
      expect(response.status).not_to render_template(:index)
      redirect_to root_path
    end
    it "it won't render the :index template if your user is not sign_in (user status is Pending)" do
      userpending = {email: 'test@test.com', role: 'teacher', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(userpending)
      get users_path
      expect(response.status).not_to render_template(:index)
      redirect_to root_path
    end
  end
  describe "get show_user_path when the user is login" do
    it "renders the :show user template if your user is sign_in and your status is Approved" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      get user_show_path(id: @user.id)
      expect(response.status).to render_template(:show)
      # redirect_to user_show_path
    end
  end
  describe "get edit_user_path" do
    it "renders the :edit template if your user is sign_in and your status is Approved" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      get user_edit_path(id: @user.id)
      expect(response.status).to render_template(:edit)
    end
    it "won't renders the :edit template if your user is sign_in and your status is Pending" do
      userpending = {email: 'test@test.com', role: 'teacher', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(userpending)
      sign_in @user
      @user.confirm
      get user_edit_path(id: @user.id)
      expect(response).not_to render_template(:edit)
      redirect_to root_path
    end
    it "won't renders the :edit template if your user is NOT sign_in and status is pending" do
      userpending = {email: 'test@test.com', role: 'teacher', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(userpending)
      # We do not sign in the user
      get user_edit_path(id: @user.id)
      expect(response).not_to render_template(:edit)
      redirect_to users_sign_in_path
      # expect(response).to redirect_to users_sign_in_path
    end
  end
end

