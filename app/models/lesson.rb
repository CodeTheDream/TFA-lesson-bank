class Lesson < ApplicationRecord
  belongs_to :course 
  has_many :documents, dependent: :delete_all 
  has_many :key_words, dependent: :delete_all
  has_many :tags, through: :key_words, dependent: :delete_all
   

  validates :title, presence: true
  validates :description, presence: true
  validates :units_covered, presence: true

  def tag_list
    self.tags.pluck :name
  end
end
