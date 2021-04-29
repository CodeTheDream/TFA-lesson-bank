class AddUserToCourses < ActiveRecord::Migration[6.0]
  def change
    add_reference :courses, :user_id
  end
end
