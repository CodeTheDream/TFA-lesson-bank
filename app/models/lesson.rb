class Lesson < ApplicationRecord
  has_many :documents 
  belongs_to :course  
  validates :title, presence: true
  validates :description, presence: true
  has_many :tagginglessons
  has_many :tags, through: :tagginglessons
  def tag_list
    self.tags.collect do |tag|
    tag.name
    end.join(", ")
  end
  def tag_list=(tags_string)
    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
    new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
    self.tags = new_or_found_tags
  end
end
