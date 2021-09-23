class RenameCourseGradesAttributes < ActiveRecord::Migration[6.0]
  def change
    remove_column :courses_grades, :grades_id
    remove_column :courses_grades, :courses_id
    add_reference :courses_grades, :grade
    add_reference :courses_grades, :course
  end
end
