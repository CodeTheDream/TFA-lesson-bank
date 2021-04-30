class AddUnitsCoveredToLessons < ActiveRecord::Migration[6.0]
  def change
    add_column :lessons, :units_covered, :string
  end
end
