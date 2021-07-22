class Course < ApplicationRecord
  include TagList, CourseSearch
  
#  searchkick word_middle: [ :title, :description, :subject, :grade_level, :state, :district], merge_mappings: true

  belongs_to :user
  has_many :lessons, dependent: :destroy
  has_many :documents, dependent: :destroy 
  has_many :key_words, dependent: :destroy
  has_many :tags, through: :key_words 
#  belongs_to :searchable, polymorphic: true
  has_one :search_item, as: :searchable

#  validates :title, presence: true
  validates :description, presence: true
  validates :subject, presence: true
  validates :grade_level, presence: true
  validates :state, presence: true
  validates :district, presence: true

#  def search_data attrs = attributes.dup                                            
#    relational = {
#      title: title,
#      description: description,
#      subject: subject,
#      grade_level: grade_level,
#      state: state,
#      district: district,
#    }                                                                               
#  end                          

  def available_grade_levels 
    %w[Prek-K K 1 2 3 4 5 6 7 8 9 10 11 12]
  end
end
