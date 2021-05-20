class Course < ApplicationRecord
    belongs_to :user
    has_many :lessons
    has_many :documents
    validates :title, presence: true
    validates :subject, presence: true
    validates :grade_level, presence: true
    validates :title, presence: true
    validates :state, presence: true
    validates :district, presence: true
    validates :grade_level, numericality: { only_integer: true }
    validates :description, presence: true
end
