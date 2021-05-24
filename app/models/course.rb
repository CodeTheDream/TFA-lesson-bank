class Course < ApplicationRecord
  belongs_to :user
  has_many :lessons
  has_many :documents
  has_many :key_words
  has_many :tags, through: :key_words

  validates :title, presence: true
  validates :subject, presence: true
  validates :grade_level, presence: true
  validates :title, presence: true
  validates :state, presence: true
  validates :district, presence: true
  validates :grade_level, numericality: { only_integer: true }
  validates :description, presence: true

#  accepts_nested_attributes_for :tags

  def tag_list
    self.tags.pluck :name
  end
end
