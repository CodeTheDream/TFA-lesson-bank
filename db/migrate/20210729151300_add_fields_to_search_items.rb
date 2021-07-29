class AddFieldsToSearchItems < ActiveRecord::Migration[6.0]
  def change
    add_column :search_items, :title, :string
    add_column :search_items, :description, :string
    add_column :search_items, :subject, :string
    add_column :search_items, :grade_level, :string
    add_column :search_items, :state, :string
    add_column :search_items, :district, :string
    add_column :search_items, :units_covered, :string
    add_column :search_items, :course_id, :string
  end
end
