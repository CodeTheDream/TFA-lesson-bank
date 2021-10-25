# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user/welcome_email
  def welcome_email
    UserMailer.with(user: User.last).welcome_email
  end
  # Preview this email at http://localhost:3000/rails/mailers/user/new_registration
  def new_registration
    UserMailer.with(user: User.last).new_registration
  end
  # Preview this email at http://localhost:3000/rails/mailers/user/update_user
  def update_user
    UserMailer.with(user: User.last).update_user
  end
end
