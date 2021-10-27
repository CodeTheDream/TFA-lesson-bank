class RemoveStartFromFavorites < ActiveRecord::Migration[6.0]
  def change
    remove_column :favorites, :start, :boolean
  end
end
