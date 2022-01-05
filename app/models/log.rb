class Log < ApplicationRecord
  belongs_to :user
  #User can save one record on the log when the user download the file 
  validates :user_id, uniqueness: { 
    scope: [:user_id, :document_id],
    message: 'User can only save the log one time'
  }
end 