class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :courses, dependent: :destroy 
  has_many :favorites, dependent: :destroy

  before_create :set_default_role, :set_default_status
  after_create :send_email_confirmation
# email notification
  
  after_commit :reindex_user
  def reindex_user
    user = User.find id
    SearchItem.reindex if user.present?
  end

  # def user_reindex
  #   # index = User.user_reindex
  #   index = User.user_reindex(async: true, refresh_interval: "5s")
  #   User.search_index.promote(index[:index_name], update_refresh_interval: true)
  #   User.user_reindex
  #   # user = User.find id
  #   # user.reindex if user.present?
  # end

  # after_save :update_user
  # after_destroy :update_user

  # def update_user
  #   byebug
  #   user(cache: false).__elasticsearch__.reindex_user if User.respond_to?('__elasticsearch__')
  # end
  
  def send_email_confirmation
    UserMailer.with(user: self).new_registration.deliver_now
    UserMailer.with(user: self).welcome_email.deliver_now
  end

  def set_default_role
    self.role ||= :teacher
  end
  
  def name
    "#{first_name} #{last_name}"
  end

  def set_default_status
    self.status ||= :Pending
  end

end
