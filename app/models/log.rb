class Log < ApplicationRecord
  belongs_to :user
  belongs_to :document
  #User can save one record on the log when the user download the file 
  validates :user_id, uniqueness: { 
    scope: [:user_id, :document_id],
    message: 'User can only save the log one time'
  }

  def description
    "The user #{user.first_name} #{user.last_name} at #{user.email} downloaded the file #{document.name}"
  end
end 
