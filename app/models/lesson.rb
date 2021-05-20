class Lesson < ApplicationRecord
  has_many :documents 
  belongs_to :course  
  validates :title, presence: true
  validates :description, presence: true
  validates :tags, presence: true
end
