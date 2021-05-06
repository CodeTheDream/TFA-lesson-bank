class AddCourseRefToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_reference :documents, :course, foreign_key: true
  end
end
