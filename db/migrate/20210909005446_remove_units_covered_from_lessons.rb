class RemoveUnitsCoveredFromLessons < ActiveRecord::Migration[6.0]
  def change
    remove_column :lessons, :units_covered, :string
  end
end
