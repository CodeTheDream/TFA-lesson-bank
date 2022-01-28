class AddCreatorIdToLog < ActiveRecord::Migration[6.0]
  def change
    add_column :logs, :creator_id, :integer
  end
end
