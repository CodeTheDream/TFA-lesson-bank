class Document < ApplicationRecord
  has_one_attached :document
  belongs_to :lesson, optional: true
  belongs_to :course, optional: true
  
  private
  def correct_document_mime_type
    if document.attached? && !document.content_type.in?(%w(application/msword application/pdf))
      document.purge # delete the uploaded file
      errors.add(:document, 'Must be a PDF or a DOC file')
    end
  end
end
