class RemoveSubjectFromLessons < ActiveRecord::Migration[6.0]
  def change
    remove_column :lessons, :subject, :string
  end
end
