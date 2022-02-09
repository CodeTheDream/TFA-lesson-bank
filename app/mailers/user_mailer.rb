class UserMailer < ApplicationMailer

  def new_registration
    @user = params[:user]
    @url  = 'https://tfa-lesson-bank-2nhhr.ondigitalocean.app/users/sign_in'
    mail(
      from: "Teach for America team",
      to: @user.email,
      subject: "New User Signup: #{@user.email}")
      # subject: 'Welcome to Teach for America')
  end
  def update_email
    @user = params[:user]
    @url  = 'https://tfa-lesson-bank-2nhhr.ondigitalocean.app/users/sign_in'
    mail(
      from: "Teach for America team",
      to: @user.email,
      subject: "You Update your email: #{@user.email}")
  end
  def new_email
    @user = params[:user]
    @url  = 'https://tfa-lesson-bank-2nhhr.ondigitalocean.app/users/sign_in'
    mail(
      from: "Teach for America team",
      to: @user,
      subject: "You Update your email: #{@user.email}")
  end
  # def password_reset_action
  #   @user = params[:user]
  #   @url  = 'https://tfa-lesson-bank-2nhhr.ondigitalocean.app/users/sign_in'
  #   # @user = User.find_by_email(params[:email])
  #   UserMailer.password_reset.deliver
  # end
end

