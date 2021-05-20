class Tag < ApplicationRecord
  has_many :taggingcourses
  has_many :courses, through: :taggingcourses
  def to_s
    name
  end
end
