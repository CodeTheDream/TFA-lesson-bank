class Course < ApplicationRecord
    validates :grade_level, numericality: { only_integer: true }
    # ARE WE GOING TO CHECK LENGHTH Y/N
    # validates :grade_level, length: { is: 10}
    belongs_to :user
    has_many :lessons, through: :courses 
end
