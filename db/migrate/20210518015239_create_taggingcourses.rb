class CreateTaggingcourses < ActiveRecord::Migration[6.0]
  def change
    create_table :taggingcourses do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
