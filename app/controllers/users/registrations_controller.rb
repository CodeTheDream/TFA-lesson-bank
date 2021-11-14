# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  respond_to :html, :json
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :configure_sign_up_params, only: [:create]
  before_action :set_user, only: [:show, :update, :edit, :destroy]  
  before_action :verify_role!, only: [:index,:show,:edit, :update, :delete] 
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  def index
    @users = User.all
    @users = @users.paginate(page: params[:page], :per_page => 3)
  end 

  # POST /resource
  def create
    @user = User.new configure_sign_up_params
    @user.role = 'teacher'
    if @user.save
      UserMailer.with(user: @user).new_registration.deliver_now
      UserMailer.with(user: @user).welcome_email.deliver_now
      redirect_to root_path, notice: 'Success! Check your email to confirm your account'
    else
      redirect_to root_path, notice: 'User cannot be added'
    end
  end

  def new
    @user = User.new   
    @users = User.all
  end

  def show  
  end
 
  def destroy
    if current_user.role == 'admin'
      authorize @user
      @user.destroy
      redirect_to '/users', notice: 'User was successfully destroyed'
    else
      redirect_to '/users', notice: 'User could not be destroyed'
    end
  end

  def edit 
  end
  # if @lesson.update(lesson_params.except(:documents_less))
  # redirect_to user_edit_path(@user), notice: 'User could not be updated'

  def update
    if @user.update configure_registration_update_parameters
      if configure_registration_update_parameters[:email] != @user.email
        @newemail = configure_registration_update_parameters[:email]
        @previous_email = @user.email
        @user.update_attribute(:previous_email, @previous_email)
        UserMailer.with(user: @user).update_email.deliver_now
        UserMailer.with(user: @user, email: @newemail).new_email.deliver_now
        # send a method with confirmation to both emails
        # user account will be pending until confirmation
        # redirect_to users_sign_out
        redirect_to root_path #sign_out @user
      else
      redirect_to users_path, notice: 'User was successfully updated'
      end
    else
      flash.now.alert = @user.errors.full_messages.to_sentence
      redirect_to user_edit_path(@user), notice: 'User could not be updated'
    end
  end      
      
    # else
    #   flash.now.alert = @user.errors.full_messages.to_sentence
    #   redirect_to user_edit_path(@user), notice: 'User could not be updated'
    # end

  
#@user.errors.messages
#@user.update!  configure_registration_update_parameters
#owner and admin pundit
#verify role for registration controller
#admin updating another user
#teacher updating myself
#record vs user


  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    params.require(:user).permit(:email, :role, :password, :password_confirmation, :unconfirmed_email, :first_name, :last_name)
    # devise_parameter_sanitizer.permit(:email, :role, :password, :password_confirmation, :unconfirmed_email, :first_name, :last_name) 
  end

 private
  
  def set_user
    @user = User.find params[:id]
  end

  def verify_role!
    authorize @user || User
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to root_path
  end

  def catch_not_found(e)
    Rails.logger.debug("We had a not found exception.")
    flash.alert = e.to_s
    redirect_to courses_path
  end

  def minimum_password_length
    if devise_mapping.validatable?
      @minimum_password_length = resource_class.password_length.min
    end
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
