class Comment < ApplicationRecord
  belongs_to :lesson, optional: true
  belongs_to :course, optional: true
  belongs_to :user

  validates :message, presence: true
end
