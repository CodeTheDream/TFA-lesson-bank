class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :verify_role!


  def index
    @users = User.all
  end

  def edit  
    #Call to user policy
    authorize @user
    byebug
    @user = User.find params[:format]
  end

  def update
    @user = User.find params[:id]
    authorize @user
    byebug
    if @user.role == 'admin'
      if @user.update  configure_registration_update_parameters
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

  def show  
    @user = User.find params[:id]
  end

  private
  # # Use callbacks to share common setup or constraints between actions.
  def set_user
    byebug
    @service = Service.find(params[:id])
  end

  def verify_role!
    byebug
    @user || User
  end

  # Only allow a list of trusted parameters through.
  def user_params
    byebug
    params.require(:user).permit(:email, :role, :password, :password_confirmation, :unconfirmed_email, :first_name, :last_name)
  end

  def catch_not_found(e)
    Rails.logger.debug("We had a not found exception.")
    flash.alert = e.to_s
    redirect_to services_path
  end

 
end