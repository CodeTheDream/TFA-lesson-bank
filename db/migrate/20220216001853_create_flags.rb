class CreateFlags < ActiveRecord::Migration[6.0]
  def change
    create_table :flags do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :flagable_id
      t.string :flagable_type

      t.timestamps
    end
  end
end
