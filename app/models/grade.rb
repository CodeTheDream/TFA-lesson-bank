class Grade < ApplicationRecord
  has_many :courses_grades, dependent: :destroy##check this and make unique and has many courses

   validates :grade_level, presence: true, uniqueness: true

end
