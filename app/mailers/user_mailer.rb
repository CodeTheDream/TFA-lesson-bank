class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url  = 'http://tfa.org/login'
    mail(to: @user.email, subject: 'Welcome to Teach for America')
  end
end

