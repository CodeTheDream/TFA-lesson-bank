class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attributes = [:role, :email, :password, :password_confirmation, :unconfirmed_email]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  end

  def configure_sign_up_parameters
    params.require(:user).permit(:email, :role, :password, :password_confirmation, :unconfirmed_email)
  end
end
