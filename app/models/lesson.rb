class Lesson < ApplicationRecord
  include TagList
  belongs_to :course 
  has_many :documents, dependent: :destroy 
  has_many :key_words, dependent: :destroy
  has_many :tags, through: :key_words
   

  validates :title, presence: true
  validates :description, presence: true
  validates :units_covered, presence: true

end
