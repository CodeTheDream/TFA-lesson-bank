class Tag < ApplicationRecord
  has_many :key_words, :dependent => :destroy
  has_many :courses, through: :key_words
  has_many :lessons, through: :key_words
end
