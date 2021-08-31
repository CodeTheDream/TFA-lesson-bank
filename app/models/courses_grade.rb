class CoursesGrade < ApplicationRecord
  belongs_to :courses
  belongs_to :grades
end
