class RemoveCourseFromLessons < ActiveRecord::Migration[6.0]
  def change
    remove_column :lessons, :course, :string
  end
end
