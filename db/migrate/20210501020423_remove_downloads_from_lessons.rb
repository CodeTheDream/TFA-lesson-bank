class RemoveDownloadsFromLessons < ActiveRecord::Migration[6.0]
  def change
    remove_column :lessons, :downloads, :integer
  end
end
