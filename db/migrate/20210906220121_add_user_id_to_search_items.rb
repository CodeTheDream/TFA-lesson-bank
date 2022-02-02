class AddUserIdToSearchItems < ActiveRecord::Migration[6.0]
  def change
    add_column :search_items, :user_id, :int
  end
end
