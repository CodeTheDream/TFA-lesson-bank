class Course < ApplicationRecord
  belongs_to :user
  has_many :lessons
  has_many :documents
  validates :title, presence: true
  validates :description, presence: true
  validates :subject, presence: true
  validates :grade_level, presence: true
  validates :title, presence: true
  validates :state, presence: true
  validates :district, presence: true
  validates :grade_level, presence: true
  validates :grade_level, numericality: { only_integer: true }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :created_at, presence: true
  validates :updated_at, presence: true
  has_many :taggingcourses
  has_many :tags, through: :taggingcourses
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
