class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :courses, dependent: :destroy 
  has_many :comments, dependent: :destroy 
  has_many :favorites, dependent: :destroy
  has_many :flags, dependent: :destroy
  has_many :logs, dependent: :destroy

  before_create :set_default_role, :set_default_status
# email notification
  
  def set_default_role
    self.role ||= :user
  end
  
  def name
    "#{first_name} #{last_name}"
  end

  def set_default_status
    self.status ||= :Approved
  end

end
