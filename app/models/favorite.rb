class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favoritable, polymorphic: true
  #User can only favorite an item once 
  validates :user_id, uniqueness: { 
    scope: [:favoritable_id, :favoritable_type],
    message: 'can only favorite an item once'
  }

  after_commit :search_item_reindex
  after_destroy :search_item_reindex

  def search_item_reindex
    search_item = SearchItem.find_by(searchable_id: favoritable_id, searchable_type: favoritable_type)
    if search_item.present?
      search_item.update(favorited: Favorite.where(favoritable_id: favoritable_id, favoritable_type: favoritable_type).count)
      search_item.reindex
    end
  end
end
