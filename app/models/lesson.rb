class Lesson < ApplicationRecord
  has_many :documents 
  belongs_to :course  
end
