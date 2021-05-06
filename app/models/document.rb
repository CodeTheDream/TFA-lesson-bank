class Document < ApplicationRecord
  belongs_to :lesson, optional: true
  belongs_to :course, optional: true
end
