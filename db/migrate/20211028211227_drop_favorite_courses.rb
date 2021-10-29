class DropFavoriteCourses < ActiveRecord::Migration[6.0]
  def change
    drop_table :favorite_courses
  end
end
