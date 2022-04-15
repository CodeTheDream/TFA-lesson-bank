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
      @user = FactoryBot.create(:user, role:'admin')
      sign_in @user
      @user.confirm
      get users_path
      expect(response.status).to render_template(:index)
      redirect_to users_path
    end
    it "it won't render the :index template if your user is sign_in with user role" do
      @user = FactoryBot.create(:user, role:'user')
      sign_in @user
      @user.confirm
      get users_path
      expect(response.status).not_to render_template(:index)
      redirect_to users_path
    end
    it "it won't render the :index template if your user is sign_in with user creator" do
      @user = FactoryBot.create(:user, role:'creator')
      sign_in @user
      @user.confirm
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.new(course_hash)
      get users_path
      expect(response.status).not_to render_template(:index)
      redirect_to users_path
    end
    it "it won't render the :index template if your user is sign_in, but your user status is Pending" do
      userpending = {email: 'test@test.com', role: 'creator', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}      
      @user = User.create(userpending)
      sign_in @user
      @user.confirm
      get users_path
      expect(response.status).not_to render_template(:index)
      redirect_to root_path
    end
    it "it wont render the :index template if your user is not sign_in (user status is Approved)" do
      @user = FactoryBot.create(:user)
      get users_path
      expect(response.status).not_to render_template(:index)
      redirect_to root_path
    end
    it "it won't render the :index template if your user is not sign_in (user status is Pending)" do
      userpending = {email: 'test@test.com', role: 'creator', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}      
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
      redirect_to user_show_path
    end
    it "it won't render the :show user template if your user is sign_in and your status is Pending" do
      userpending = {email: 'test@test.com', role: 'creator', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(userpending)
      sign_in @user
      @user.confirm
      get user_show_path(id: @user.id)
      expect(response.status).not_to render_template(:show)
      redirect_to root_path
    end
    it "won't renders the :show user template if your user is NOT sign_in and status is pending" do
      userpending = {email: 'test@test.com', role: 'creator', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(userpending)
      # We do not sign in the user
      get user_show_path(id: @user.id)
      expect(response.status).not_to render_template(:show)
      redirect_to users_sign_in_path
      # expect(response).to redirect_to users_sign_in_path
    end
    it "it won't render the :index template if your user is not sign_in (user status is Approved)" do
      @user = FactoryBot.create(:user)
      get user_show_path(id: @user.id)
      expect(response.status).not_to render_template(:show)
      redirect_to root_path
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
      userpending = {email: 'test@test.com', role: 'creator', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(userpending)
      sign_in @user
      @user.confirm
      get user_edit_path(id: @user.id)
      expect(response).not_to render_template(:edit)
      redirect_to root_path
    end
    it "won't renders the :edit template if your user is NOT sign_in and status is pending" do
      userpending = {email: 'test@test.com', role: 'creator', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(userpending)
      # We do not sign in the user
      get user_edit_path(id: @user.id)
      expect(response).not_to render_template(:edit)
      redirect_to users_sign_in_path
    end
    it "won't renders the :edit template if your role is creator and you try to edit another creator's account" do
      creator1 = {email: 'test1@test.com', role: 'creator', first_name: 'Test1', last_name: 'Lastname', password: 'Pa$$word111', status: 'Approved'}
      creator2 = {email: 'test2@test.com', role: 'creator', first_name: 'Test2', last_name: 'Lastname', password: 'Pa$$word111', status: 'Approved'}
      @user1 = User.create(creator1)
      @user2 = User.create(creator2)
      #signin creator1
      sign_in @user1
      @user1.confirm
      # We do not sign in the user
      get user_edit_path(id: @user2.id)
      expect(response).not_to render_template(:edit)
      redirect_to users_sign_in_path
    end
    it "will render the :edit template if your role is admin with status approved and you try to edit a teacher's account with status Approved" do
      useradmin1 = {email: 'admin1@test.com', role: 'admin', first_name: 'Admin1', last_name: 'Lastname', password: 'Pa$$word111', status: 'Approved'}
      creator = {email: 'creator@test.com', role: 'creator', first_name: 'Creator', last_name: 'Lastname', password: 'Pa$$word111', status: 'Approved'}
      @admin1 = User.create(useradmin1)
      @creator1 = User.create(creator)
      #signin admin with status Approved
      sign_in @admin1
      @admin1.confirm
      #Admin try to edit teacher with status Approved
      get user_edit_path(id: @creator1.id)
      expect(response).to render_template(:edit)
      expect(response.status).to render_template(:edit)
    end
  end
  describe "delete user according to your status" do
    it "deletes a user record if your user (adminsitrator) is sign_in and your status is Approved" do
      useradmin = {email: 'test@test.com', role: 'admin', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Approved'}
      @user = User.create(useradmin)
      sign_in @user
      @user.confirm
      expect {delete user_delete_path(id: @user.id)}.to change(User, :count)
      expect(response).to redirect_to users_path
    end
    it "it won't delete the user record if your user (adminsitrator) is sign_in and your status is Pending" do
      useradmin = {email: 'test@test.com', role: 'admin', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(useradmin)
      sign_in @user
      @user.confirm
      expect {delete user_delete_path(id: @user.id)}.not_to change(User, :count)
      expect(response).to redirect_to root_path
    end
    it "it won't delete the user record if your user (creator) is sign_in and your status is Approved" do
      usercreator = {email: 'test@test.com', role: 'creator', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Approved'}
      @user = User.create(usercreator)
      sign_in @user
      @user.confirm
      expect {delete user_delete_path(id: @user.id)}.not_to change(User, :count)
      expect(response).to redirect_to users_path
    end
    it "it won't delete the user record if your user (creator) is sign_in and your status is Pending" do
      usercreator = {email: 'test@test.com', role: 'creator', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(usercreator)
      sign_in @user
      @user.confirm
      expect {delete user_delete_path(id: @user.id)}.not_to change(User, :count)
      expect(response).to redirect_to users_path
    end
  end
  describe "create the new_user with status pending" do
    it "won't create the new_user with no email" do
      usercreator = {email: '', role: 'creator', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(usercreator)
      expect(@user.errors[:email]).to include("can't be blank")
      #it won't create the user and it will send error message
    end
    it "won't create the new_user without a valid email" do
      usercreator = {email: 'testdotcom', role: 'creator', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(usercreator)
      expect(@user.errors[:email]).to include("is invalid")
      #it won't create the user and it will send error message
    end
    it "create the new_user creator with role pendig and will redirect to the root page and wait for confirmation and an admin to chenge status to Approved" do
      usercreator = {email: 'test@test.com', role: 'creator', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(usercreator)
      @user.save
      #Call the method from the model and send email confirmation 
      expect { @user.send_email_confirmation }.to change { ActionMailer::Base.deliveries.count }.by(1)
      get root_path
    end
  end
end

