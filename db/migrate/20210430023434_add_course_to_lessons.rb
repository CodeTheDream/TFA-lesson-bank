class AddCourseToLessons < ActiveRecord::Migration[6.0]
  def change
    add_reference :lessons, :course_id
  end
end
