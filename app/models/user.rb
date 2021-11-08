class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :courses, dependent: :destroy 
  # has_many :favorite_courses, dependent: :destroy  # just the 'relationships'
  # has_many :favorites, through: :favorite_courses, source: :course # the actual courses a user favorites
  has_many :favorites, dependent: :destroy
  # validates :first_name, presence: true
  # validates :last_name, presence: true

  after_initialize :set_default_role, :if => :new_record?
  after_create :send_email_confirmation

  # def send_email_confirmation
  #   UserMailer.with(user: self).new_registration.deliver_now
  #   UserMailer.with(user: self).welcome_email.deliver_now
  # end

  def set_default_role
    self.role ||= :teacher
  end
  
  def name
    "#{first_name} #{last_name}"
  end
end
