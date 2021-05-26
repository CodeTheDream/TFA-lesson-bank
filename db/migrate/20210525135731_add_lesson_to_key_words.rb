class AddLessonToKeyWords < ActiveRecord::Migration[6.0]
  def change
    add_reference :key_words, :lesson, foreign_key: true
  end
end
