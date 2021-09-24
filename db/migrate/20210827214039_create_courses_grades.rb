class CreateCoursesGrades < ActiveRecord::Migration[6.0]
  def change
    create_table :courses_grades do |t|
      t.belongs_to :courses
      t.belongs_to :grades
      t.timestamps
    end
  end
end
