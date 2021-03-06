class Course < ApplicationRecord
  include TagList
  
  belongs_to :user
  has_many :lessons, dependent: :destroy
  has_many :documents, dependent: :destroy 
  has_many :key_words, dependent: :destroy
  has_many :tags, through: :key_words 
  has_one :search_item, as: :searchable, dependent: :delete
  has_many :favorites, as: :favoritable, dependent: :destroy
  has_many :flags, as: :flagable, dependent: :destroy
  has_many :courses_grades, dependent: :destroy
  has_many :grades, through: :courses_grades, dependent: :destroy
  # returns the users that favorite a course

  validates :title, presence: true
  validates :description, presence: true
  validates :subject, presence: true
  validates :state, presence: true
  validates :district, presence: true
  validates :title, presence: true

  def available_grade_levels 
    %w[Prek-K K 1 2 3 4 5 6 7 8 9 10 11 12]
  end

  def self.subjects
    ["Art", "English", "Math", "Music", "Science", "Technology", "Social Studies", "Special Education", "Health/PE", "Foreign Language" ]
  end

  def self.districts
    %w[ Charlotte-Mecklenburg Durham Edgecombe Guilford Harnett Johnston Kipp Pitt Wake Warren]
  end
end
