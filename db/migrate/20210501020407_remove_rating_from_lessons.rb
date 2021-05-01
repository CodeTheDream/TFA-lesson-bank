class RemoveRatingFromLessons < ActiveRecord::Migration[6.0]
  def change
    remove_column :lessons, :rating, :integer
  end
end
