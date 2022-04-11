class AddFavoritedToSearchItems < ActiveRecord::Migration[6.0]
  def change
    add_column :search_items, :favorited, :integer
  end
end
