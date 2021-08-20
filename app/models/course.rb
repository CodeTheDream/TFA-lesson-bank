class Course < ApplicationRecord
  include TagList
  
  belongs_to :user
  has_many :lessons, dependent: :destroy
  has_many :documents, dependent: :destroy 
  has_many :key_words, dependent: :destroy
  has_many :tags, through: :key_words 
  has_one :search_item, as: :searchable, dependent: :destroy
  has_many :favorite_courses, dependent: :destroy  # just the 'relationships'
  has_many :favorited_by, through: :favorite_courses , source: :user # the actual users favoriting a course
  # returns the users that favorite a course

  validates :title, presence: true
  validates :description, presence: true
  validates :subject, presence: true
  validates :grade_level, presence: true
  validates :state, presence: true
  validates :district, presence: true
  validates :title, presence: true

  def available_grade_levels 
    %w[Prek-K K 1 2 3 4 5 6 7 8 9 10 11 12]
  end
end
