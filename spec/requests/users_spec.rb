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
  describe "get edit_user_path" do
    it "renders the :edit template if your user status is Approved" do
      @user = FactoryBot.create(:user)
      sign_in @user
      @user.confirm
      get user_edit_path(id: @user.id)
      expect(response.status).to render_template(:edit)
    end
    it "won't renders the :edit template if your user status is Pending" do
      userpending = {email: 'test@test.com', role: 'teacher', first_name: 'Test', last_name: 'Lastname', password: 'Pa$$word111', status: 'Pending'}
      @user = User.create(userpending)
      sign_in @user
      @user.confirm
      get user_edit_path(id: @user.id)
      expect(response).to redirect_to root_path
    end
  end
end
  # POST /resource
  # def create
  #   @user = User.new configure_sign_up_params
  #   @user.role = 'teacher'
  #   if @user.save
  #     UserMailer.with(user: @user).new_registration.deliver_now
  #     UserMailer.with(user: @user).welcome_email.deliver_now
  #     redirect_to root_path, notice: 'Success! Check your email to confirm your account'
  #   else
  #     redirect_to root_path, notice: 'User cannot be added'
  #   end
  # end

  # describe "POST users#sign_up" do
  #   context "valid user credentials and status Approved" do
  #     before do
  #       # user_hash = {email: 'MissBliss@JFKHS.com', role: 'teacher', first_name: 'Carrie', last_name: 'Bliss', password: 'Pa$$word111', status: 'Approved'}
  #       # User.create user_hash
  #       # post :create, user: {email: 'MissBliss@JFKHS.com', role: 'teacher', first_name: 'Carrie', last_name: 'Bliss', password: 'Pa$$word111', status: 'Approved'}
  #       @user = FactoryBot.create(:user)
  #       sign_in @user
  #       get users_path
  #       byebug
  #       expect(response.status).to render_template(:index)
  #     end

      # it "creates the user" do
      #   expect(response.created?).to eq true
      # end

  #     it "logs in the user" do
  #       expect(subject.current_user.nil?).to eq false
  #     end
  #   end
  # end


  # describe "GET /users" do
  #   it "works! (now write some real specs)" do
  #     get users_path
  #     expect(response).to have_http_status(200)
  #   end
  # end
  