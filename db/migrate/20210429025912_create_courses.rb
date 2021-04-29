class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :description
      t.string :subject
      t.integer :grade_level
      t.string :state
      t.string :district
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
