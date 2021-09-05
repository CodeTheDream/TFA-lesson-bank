# class UsersController < Devise::RegistrationsController
# rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
# before_action :authenticate_user!
# before_action :configure_sign_up_params, only: [:create]
# after_action :verify_authorized

# before_action :set_user, only: [:index, :show, :edit, :update, :destroy]
# before_action :verify_role!, only: [:index, :show, :edit, :update, :destroy]
  
#   def index     
#     @users = User.all
#     @users = @users.paginate(page: params[:page], :per_page => 10)
#   end 

#   # POST /resource
#   def create
#     @user = User.new configure_sign_up_params
#     @user.role = 'teacher'
#     if @user.save
#       UserMailer.with(user: @user).new_registration.deliver_now
#       UserMailer.with(user: @user).welcome_email.deliver_now
#       redirect_to root_path, notice: 'Success! Check your email to confirm your account'
#     else
#       redirect_to root_path, notice: 'User cannot be added'
#     end
#   end

#   def new
#     @user = User.new   
#     @users = User.all
     
#   end

#   def show  
#     @user = User.find params[:id]
#   end
 
#   def destroy
#     @user = User.find params[:format]
#     if @user.destroy
#       redirect_to '/users', notice: 'User was successfully destroyed'
#     else
#       redirect_to '/users', notice: 'User could not be destroyed'
#     end
#   end

#   def edit    
#     @user = User.find params[:format]
#   end

#   def update
#     # @user = User.find params[:id]
#     if @user.role === 'admin'
#       if @user.update  configure_registration_update_parameters
#         redirect_to '/users', notice: 'User was successfully updated'
#       else
#         redirect_to '/edit', notice: 'User could not be updated'
#       end
#     else
#       if @user.update  configure_registration_update_parameters
#         redirect_to '/', notice: 'User was successfully updated'
#       else
#         redirect_to '/edit', notice: 'User could not be updated'
#       end
#     end
#   end

#   def configure_sign_up_params
#     params.require(:user).permit(:email, :role, :password, :password_confirmation, :unconfirmed_email, :first_name, :last_name)
#   end
#   private

#   def verify_role!
#     byebug
#     authorize @user || Role
#   end
  
#   # # Use callbacks to share common setup or constraints between actions.
#   def set_user
#     byebug
#     @user = current_user
    
#   end
  
#   def catch_not_found(e)
#     Rails.logger.debug("We had a not found exception.")
#     flash.alert = e.to_s
#     redirect_to courses_path
#   end
# end