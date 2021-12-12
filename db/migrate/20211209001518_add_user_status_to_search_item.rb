class AddUserStatusToSearchItem < ActiveRecord::Migration[6.0]
  def change
    add_column :search_items, :status, :string
  end
end
