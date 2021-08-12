class SearchItem < ApplicationRecord
  include SearchItemSearch
  belongs_to :searchable, polymorphic: true

  searchkick word_middle: [ :title, :description, :tags], merge_mappings: true

  def search_data attrs = attributes.dup
    if self.searchable.class == Course
      relational = {
        title: self.searchable.title,
        description: self.searchable.description,
        subject: self.searchable.subject,
        grade_level: self.searchable.grade_level,
        state: self.searchable.state,
        district: self.searchable.district,
        units_covered: "",
        course_id: "",
        tags: Course.find(self.searchable.id).tags.pluck(:name).join(' '),
      }
    # elsif self.searchable_type == 'Lesson'
    #   relational = {
    #     title: self.searchable.title,
    #     description: self.searchable.description,
    #     units_covered: "",
    #     course_id: "",
    #     tags: Lesson.find(self.searchable.id).tags.pluck(:name).join(' '),
    #   }
    else
        relational = {
        title: self.searchable.title,
        description: self.searchable.description,
        subject: "",
        grade_level: "",
        state: "",
        district: "",
        units_covered: self.searchable.units_covered,
        course_id: self.searchable.course_id.to_s,
        tags: Lesson.find(self.searchable.id).tags.pluck(:name).join(' '),
      }
    end
  end
end
