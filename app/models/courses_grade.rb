class CoursesGrade < ApplicationRecord
  belongs_to :course
  belongs_to :grade
end
