class Course < ApplicationRecord
  belongs_to :user
  has_many :lessons
  has_many :documents
  has_many :key_words
  has_many :tags, through: :key_words

  validates :title, presence: true
  validates :description, presence: true
  validates :subject, presence: true
  validates :grade_level, presence: true, numericality: { only_integer: true }
  validates :state, presence: true
  validates :district, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :created_at, presence: true
  validates :updated_at, presence: true

#  accepts_nested_attributes_for :tags

  def tag_list
    self.tags.pluck :name
  end
end
