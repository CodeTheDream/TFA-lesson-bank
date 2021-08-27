class AddTagsToSearchItems < ActiveRecord::Migration[6.0]
  def change
    add_column :search_items, :tags, :string
  end
end
