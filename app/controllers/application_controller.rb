class ApplicationController < ActionController::Base
  include Pundit
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  protected

  def configure_permitted_parameters
    attributes = [:role, :email, :password, :password_confirmation, :unconfirmed_email]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  end

  def configure_sign_up_parameters
    params.require(:user).permit(:email, :role, :password, :password_confirmation, :unconfirmed_email)
  end

  def configure_registration_parameters
    params.require(:user).permit(:email, :role, :password, :password_confirmation, :unconfirmed_email)
  end

  def configure_registration_update_parameters
    params.require(:user).permit(:email, :role, :password, :password_confirmation, :unconfirmed_email)
  end
  
  # instructions for what to do when user is signed in but does not have the
  # required role to complete an action
  def user_not_authorized(exception)
    # if they requested html, set flash alert and redirect them
    # if they requested json, give them access denied json message
    # default pundit message can be overidden by message starting with "warning"
    # raise NotAuthorizedError, "Warning: enter message here" if condition
    msg = exception.message['Warning'] ? exception.message : 'Access denied.'
    respond_to do |format|
      format.html do
        referrer = request.referrer
        # if not present or matches request url, go to root path
        path = referrer.nil? || referrer == request.url ? root_path : referrer
        redirect_to path, alert: msg
      end
      format.pdf do
        referrer = request.referrer
        # if not present or matches request url, go to root path
        path = referrer.nil? || referrer == request.url ? root_path : referrer
        redirect_to path, alert: msg
      end
      format.json { render json: { message: msg } }
    end
  end
end
