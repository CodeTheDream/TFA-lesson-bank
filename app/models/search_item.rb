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
        course_id: "",
        tags: Course.find(self.searchable.id).tags.pluck(:name).join(' '),
        user_id: Course.find(self.searchable.id).user.id,
        type: "course_type"
      }
    else
        relational = {
        title: self.searchable.title,
        description: self.searchable.description,
        subject: searchable.course.subject,
        grade_level: searchable.course.grade_level,
        state: searchable.course.state,
        district: searchable.course.district,
        course_id: self.searchable.course_id.to_s,
        tags: Lesson.find(self.searchable.id).tags.pluck(:name).join(' '),
        user_id: Lesson.find(self.searchable.id).course.user.id,
        type: "lesson_type"
      }
    end
  end
end
