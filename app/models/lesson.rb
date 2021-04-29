class Lesson < ApplicationRecord
  belongs_to :courses, optional: true
end
