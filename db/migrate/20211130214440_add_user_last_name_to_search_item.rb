class AddUserLastNameToSearchItem < ActiveRecord::Migration[6.0]
  def change
    add_column :search_items, :last_name, :string
  end
end
