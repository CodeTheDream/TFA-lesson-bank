class RemoveDistrictFromLessons < ActiveRecord::Migration[6.0]
  def change
    remove_column :lessons, :district, :string
  end
end
