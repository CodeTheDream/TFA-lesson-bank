class AddDescriptionToFlags < ActiveRecord::Migration[6.0]
  def change
    add_column :flags, :description, :string
  end
end
