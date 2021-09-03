class RemoveGradeLevelFromCourses < ActiveRecord::Migration[6.0]
  def change
    remove_column :courses, :grade_level
  end
end
