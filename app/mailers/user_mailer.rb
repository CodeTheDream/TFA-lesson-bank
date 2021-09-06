class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url  = 'http://tfa.org/login'
    mail(
      from: "Teach for America team",
      to: @user.email, 
      subject: 'Welcome to Teach for America')
  end
  def new_registration
    @user = params[:user]
    @url  = 'http://tfa.org/login'
    mail(
      from: "Teach for America team",
      to: @user.email,
      subject: "New User Signup: #{@user.email}")
      # subject: 'Welcome to Teach for America')
  end
  # def password_reset_action
  #   @user = params[:user]
  #   @url  = 'http://tfa.org/login'
  #   # @user = User.find_by_email(params[:email])
  #   UserMailer.password_reset.deliver
  # end
end
