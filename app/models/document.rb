class Document < ApplicationRecord
  has_one_attached :file
  belongs_to :lesson, optional: true
  belongs_to :course, optional: true
  has_many :logs, dependent: :destroy
  validates :name, presence: true
  validates :description, presence: true
  validates :kind, presence: true
  private
  def correct_document_mime_type
    if file.attached? && !file.content_type.in?(%w(application/msword application/pdf))
      file.purge # delete the uploaded file
      errors.add(:document, 'Must be a PDF or a DOC file')
    end
  end
end
