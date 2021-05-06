class AddLessonRefToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_reference :documents, :lesson, foreign_key: true
  end
end
