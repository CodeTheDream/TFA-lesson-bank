class AddPreviousEmailToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :previous_email, :string
  end
end
