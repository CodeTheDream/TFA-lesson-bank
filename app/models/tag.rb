class Tag < ApplicationRecord
  has_many :key_words, dependent: :delete_all 
  has_many :courses, through: :key_words, dependent: :delete_all 
  has_many :lessons, through: :key_words, dependent: :delete_all 
end
