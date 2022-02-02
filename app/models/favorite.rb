class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favoritable, polymorphic: true
  #User can only favorite an item once 
  validates :user_id, uniqueness: { 
    scope: [:favoritable_id, :favoritable_type],
    message: 'can only favorite an item once'
  }
end
