class CreateGrades < ActiveRecord::Migration[6.0]
  def change
    create_table :grades do |t|
      t.string :grade_level
      t.timestamps
    end
  end
end
