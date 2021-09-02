class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  has_many :courses, dependent: :destroy 
  has_many :favorite_courses, dependent: :destroy  # just the 'relationships'
  has_many :favorites, through: :favorite_courses, source: :course # the actual courses a user favorites
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  def name
    "#{first_name} #{last_name}"
  end
end
