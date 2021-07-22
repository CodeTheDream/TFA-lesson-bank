class SearchItem < ApplicationRecord
  belongs_to :searchable, polymorphic: true
#  has_one :courses, as: :searchable
#  has_one :lessons, as: :searchable

  searchkick word_middle: [ :title, :description], merge_mappings: true

  def search_data attrs = attributes.dup
    byebug
    if self.searchable_type == 'Course'
      relational = {
        title: self.searchable.title,
        description: self.searchable.description,
        subject: self.searchable.subject,
        grade_level: self.searchable.grade_level,
        state: self.searchable.state,
        district: self.searchable.district,
        units_covered: "",
        course_id: "",
      }
    else
      relational = {
        title: self.searchable.title,
        description: self.searchable.description,
        subject: "",
        grade_level: "",
        state: "",
        district: "",
        units_covered: self.searchable.units_covered,
        course_id: self.searchable.course_id,
      }
    end
  end
end
