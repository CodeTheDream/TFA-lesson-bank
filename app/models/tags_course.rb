class TagsCourse < ApplicationRecord
  belongs_to :tag
  belongs_to :course
end
