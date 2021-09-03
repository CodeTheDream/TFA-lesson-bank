class Grade < ApplicationRecord
  has_many :courses_grades, dependent: :destroy##check this and make unique and has many courses
  has_many :courses, through: :courses_grades, dependent: :destroy
  
  validates :grade_level, presence: true

end
