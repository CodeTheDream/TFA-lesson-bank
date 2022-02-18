class Flag < ApplicationRecord
  belongs_to :user
  belongs_to :flagable, polymorphic: true
  #User can only favorite an item once 
  validates :user_id, uniqueness: { 
    scope: [:flagable_id, :flagable_type],
    message: 'can only flag an item once'
  }
end
