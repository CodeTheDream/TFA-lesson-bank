# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :verify_role!
  before_action :set_user
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  def index
    #Call to user policy
    # authorize @user
    @users = User.all
    @users = @users.paginate(page: params[:page], :per_page => 10)
  end 

  # POST /resource
  def create
    @user = User.new configure_sign_up_params
    if @user.save
      # UserMailer.with(user: @user).new_registration.deliver_now
      # UserMailer.with(user: @user).welcome_email.deliver_now
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
    #Call to user policy

    # if authorize @user
      @user = User.find params[:format]
    # else
    #   respond_to do |format|
    #   format.html { redirect_to '/users', notice: 'User was successfully updated'}
    #   format.json { head :no_content }
    # end
      # format.html { render :edit }
      # format.json { render json: @user.errors, status: :unprocessable_entity }
    # end
    # if @user.edit(@user)
    #   format.html { redirect_to @user, notice: 'User was successfully edited.' }
    #   format.json { render :show, status: :ok, location: @user }
    # else
    #   format.html { render :edit }
    #   format.json { render json: @user.errors, status: :unprocessable_entity }
    # end
   
    # @user = User.find params[:format]
    # respond_to do |format|
    #   format.html { redirect_to '/users', notice: 'User was successfully updated'}
    #   format.json { head :no_content }
    # end

  end

  def update
    @user = User.find params[:id]
    authorize @user
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
    params.require(:user).permit(:email, :role, :password, :password_confirmation, :unconfirmed_email, :first_name, :last_name)
  end

private
  # def verify_role!
  #   @user || User
  # end
  def set_user
    @user = current_user
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
