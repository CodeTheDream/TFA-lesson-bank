class Course < ApplicationRecord
  include TagList, CourseSearch
  
#  searchkick word_middle: [ :title, :description, :subject, :grade_level, :state, :district, :start_date, :end_date], merge_mappings: true
  searchkick

  belongs_to :user
  has_many :lessons, dependent: :destroy
  has_many :documents, dependent: :destroy 
  has_many :key_words, dependent: :destroy
  has_many :tags, through: :key_words 


  validates :title, presence: true
  validates :description, presence: true
  validates :subject, presence: true
  validates :grade_level, presence: true, numericality: { only_integer: true }
  validates :state, presence: true
  validates :district, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

#  def search_data
#    attributes.merge(
#      title: title,
#      description: description,
#      subject: subject,
#      grade_level: grade_level,
#      state: state,
#      district: district,
#      start_date: start_date,
#      end_date: end_date
#    )
#  end

end
