# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user/new_registration
 
  def new_registration
    UserMailer.with(user: User.last).new_registration
  end
  def update_email
    UserMailer.with(user: User.last).update_email
  end
  def new_email
    UserMailer.with(user: User.last).new_email
  end
  def send_flag_notification
    UserMailer.with(user: User.last).send_flag_notification
  end
end
