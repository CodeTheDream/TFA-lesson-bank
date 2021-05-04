class CreateLessons < ActiveRecord::Migration[6.0]
  def change
    create_table :lessons do |t|
      t.string :title
      t.string :description
      t.string :subject
      t.string :course
      t.string :state
      t.string :district
      t.integer :rating
      t.integer :downloads
      t.string :tags

      t.timestamps
    end
  end
end
