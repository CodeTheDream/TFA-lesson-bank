class RemoveTagsFromLessons < ActiveRecord::Migration[6.0]
  def change
    remove_column :lessons, :tags
  end
end
