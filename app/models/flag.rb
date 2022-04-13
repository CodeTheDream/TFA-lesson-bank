class Flag < ApplicationRecord
  belongs_to :user
  belongs_to :flagable, polymorphic: true
  #User can only favorite an item once 
  validates :user_id, uniqueness: { 
    scope: [:flagable_id, :flagable_type],
    message: 'can only flag an item once'
  }

  after_commit :search_item_reindex
  after_destroy :search_item_reindex

  def search_item_reindex
    search_item = SearchItem.find_by(searchable_id: flagable_id, searchable_type: flagable_type)
    search_item.reindex if search_item.present?
  end

end
