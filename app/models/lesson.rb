class Lesson < ApplicationRecord
  include TagList

  belongs_to :course 
  has_many :documents, dependent: :destroy 
  has_many :key_words, dependent: :destroy
  has_many :tags, through: :key_words
  has_many :favorites, as: :favoritable, dependent: :destroy
  has_many :flags, as: :flagable, dependent: :destroy
  has_one :search_item, as: :searchable, dependent: :destroy
  
  validates :title, presence: true
  validates :description, presence: true
end
