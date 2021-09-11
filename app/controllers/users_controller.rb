class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # before_action :verify_role!
  # before_action :authenticate_user!
  # after_action :verify_authorized


  def index
    @users = User.all
    # authorize User
  end

  def show  
    @user = User.find params[:id]
    # authorize @user
  end

  # def edit  
  #   #Call to user policy
  #   # authorize @user
    
  #   @user = User.find params[:format]
  # end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # def update
  #   @user = User.find(params[:id])
  #   authorize @user
  #   if @user.update_attributes(secure_params)
  #     redirect_to users_path, :notice => "User updated."
  #   else
  #     redirect_to users_path, :alert => "Unable to update user."
  #   end
  # end

  # def update
  #   @user = User.find params[:id]
  #   # authorize @user
  #   if @user.role == 'admin'
  #     if @user.update  configure_registration_update_parameters
  #       redirect_to '/users', notice: 'User was successfully updated'
  #     else
  #       redirect_to '/edit', notice: 'User could not be updated'
  #     end
  #   else
  #     if @user.update  configure_registration_update_parameters
  #       redirect_to '/', notice: 'User was successfully updated'
  #     else
  #       redirect_to '/edit', notice: 'User could not be updated'
  #     end
  #   end
  # end

  def destroy
    user = User.find(params[:id])
    # authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end
 

  private
  # # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def verify_role!
    # byebug
    # current_user.role || User
    # @user || User
  end

  # def secure_params
  #   params.require(:user).permit(:role)
  # end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :role, :password, :password_confirmation, :unconfirmed_email, :first_name, :last_name)
  end

  def catch_not_found(e)
    Rails.logger.debug("We had a not found exception.")
    flash.alert = e.to_s
    redirect_to users_path
  end
end