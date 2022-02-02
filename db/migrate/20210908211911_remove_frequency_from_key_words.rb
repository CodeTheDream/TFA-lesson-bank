class RemoveFrequencyFromKeyWords < ActiveRecord::Migration[6.0]
  def change
    remove_column :key_words, :frequency, :integer
  end
end
