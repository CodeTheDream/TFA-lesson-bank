class ChangeGradeLevelToStringOnCourses < ActiveRecord::Migration[6.0]
  def change
    remove_column :courses, :grade_level
    add_column :courses, :grade_level, :string
  end
end
