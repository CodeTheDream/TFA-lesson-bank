class RemoveDatesFromCourses < ActiveRecord::Migration[6.0]
  def change
    remove_column :courses, :start_date
    remove_column :courses, :end_date
  end
end
