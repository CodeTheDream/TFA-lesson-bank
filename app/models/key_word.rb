class KeyWord < ApplicationRecord
  belongs_to :tag, optional: true
  belongs_to :course, optional: true
  belongs_to :lesson, optional: true
end
