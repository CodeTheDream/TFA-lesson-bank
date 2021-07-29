class CreateSearchItems < ActiveRecord::Migration[6.0]
  def change
    create_table :search_items do |t|
      t.references :searchable, polymorphic: true
      t.timestamps
    end
  end
end
