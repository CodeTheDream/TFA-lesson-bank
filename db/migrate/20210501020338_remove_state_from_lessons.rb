class RemoveStateFromLessons < ActiveRecord::Migration[6.0]
  def change
    remove_column :lessons, :state, :string
  end
end
