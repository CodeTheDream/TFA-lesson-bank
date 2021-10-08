class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.boolean :start
      t.references :user, null: false, foreign_key: true
      t.integer :favoritable_id
      t.string :favoritable_type

      t.timestamps
    end
  end
end
