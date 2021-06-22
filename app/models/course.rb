class Course < ApplicationRecord
  include TagList
  belongs_to :user
  has_many :lessons, dependent: :destroy
  has_many :documents, dependent: :destroy 
  has_many :key_words, dependent: :destroy
  has_many :tags, through: :key_words 


  validates :title, presence: true
  validates :description, presence: true
  validates :subject, presence: true
  validates :grade_level, presence: true, numericality: { only_integer: true }
  validates :state, presence: true
  validates :district, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

 
#  accepts_nested_attributes_for :tags

end
