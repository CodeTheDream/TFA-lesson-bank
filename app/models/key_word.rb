class KeyWord < ApplicationRecord
  belongs_to :tag, optional: true
  belongs_to :course, optional: true
  belongs_to :lesson, optional: true
  before_destroy :remove_tags
  def remove_tags
    if !(self.tag.nil?)
      if (self.tag.key_words.count) == 1
        tag.delete
      end 
    end
  end 
end
