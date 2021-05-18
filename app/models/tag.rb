class Tag < ApplicationRecord
  has_many :taggingcourses
  has_many :courses, through: :taggingcourses
  has_many :tagginglessons
  has_many :lessons, through: :tagginglessons
  def to_s
    name
  end
end
