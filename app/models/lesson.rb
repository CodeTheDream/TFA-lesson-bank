class Lesson < ApplicationRecord
  has_many :documents 
  belongs_to :course  
  validates :title, presence: true
  validates :description, presence: true
  validates :units_covered, presence: true

  has_many :key_words
  has_many :tags, through: :key_words

  def tag_list
    self.tags.pluck :name
  end
end
