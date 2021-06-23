class CreateKeyWords < ActiveRecord::Migration[6.0]
  def change
    create_table :key_words do |t|
      t.belongs_to :tag
      t.belongs_to :course
      t.integer :frequency
      t.timestamps
    end
  end
end
