class CreateTagginglessons < ActiveRecord::Migration[6.0]
  def change
    create_table :tagginglessons do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true

      t.timestamps
    end
  end
end
