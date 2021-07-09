class Course < ApplicationRecord
  include TagList, CourseSearch
  
  searchkick word_middle: [ :title, :description, :subject, :grade_level, :state, :district], merge_mappings: true

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

  def search_data attrs = attributes.dup                                            
    relational = {
      title: title,                                                                 
      description: description,                                                     
      subject: subject,                                                             
      grade_level: grade_level,                                                     
      state: state,                                                                 
      district: district,                                                           
    }                                                                               
  end                          
end
