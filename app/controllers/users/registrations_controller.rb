# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :configure_sign_up_params, only: [:create]
  
  before_action :set_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :verify_role!, only: [:index, :show, :edit, :update, :destroy]

  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  def index     
    @users = User.all
    @users = @users.paginate(page: params[:page], :per_page => 10)
  end 

  # POST /resource
  def create
    @user = User.new configure_sign_up_params
    byebug
    if @user.save
      hash = {name: "teacher", user_id: @user.id}
      byebug
      @user.role = Role.create hash
      byebug
      UserMailer.with(user: @user).new_registration.deliver_now
      UserMailer.with(user: @user).welcome_email.deliver_now
      redirect_to root_path, notice: 'Success! Check your email to confirm your account'
    else
      byebug
      redirect_to root_path, notice: 'User cannot be added'
    end
  end

  def new
    @user = User.new   
    @users = User.all
     
  end

  def show  
    @user = User.find params[:id]
  end
 
  def destroy
    @user = User.find params[:format]
    if @user.destroy
      redirect_to '/users', notice: 'User was successfully destroyed'
    else
      redirect_to '/users', notice: 'User could not be destroyed'
    end
  end

  def edit    
    @user = User.find params[:format]
    @roles = ["admin", "teacher"]
  end

  def update
    # @user = User.find params[:id]
    if @user.role.name === 'admin'
      if @user.update  configure_registration_update_parameters
        byebug
        if role_params[:role].present?
          role = @user.role
          role.name = role_params[:role]
          role.save
        end
        redirect_to '/users', notice: 'User was successfully updated'
      else
        redirect_to '/edit', notice: 'User could not be updated'
      end
    else
      if @user.update  configure_registration_update_parameters
        redirect_to '/', notice: 'User was successfully updated'
      else
        redirect_to '/edit', notice: 'User could not be updated'
      end
    end
  end
#@user.errors.messages
#@user.update!  configure_registration_update_parameters
#owner and admin pundit
#verify role for registration controller
#admin updating amnother user
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
    params.require(:user).permit(:email, :password, :password_confirmation, :unconfirmed_email, :first_name, :last_name)
  end
  def role_params
    params.permit(:role, :_method)
  end

private

def verify_role!
  byebug
  authorize @user || Role
  byebug
end

# # Use callbacks to share common setup or constraints between actions.
def set_user
  byebug
  @user = current_user
  byebug
end

def catch_not_found(e)
  Rails.logger.debug("We had a not found exception.")
  flash.alert = e.to_s
  redirect_to courses_path
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
