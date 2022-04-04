class SearchItem < ApplicationRecord
  include SearchItemSearch
  belongs_to :searchable, polymorphic: true

  searchkick word_middle: [ :title, :description, :tags, :last_name, :user_status], merge_mappings: true

  def search_data attrs = attributes.dup
    relational = {
      title: self.title,
      description: self.description,
      subject: self.subject,
      grade_level: self.grade_level,
      state: self.state,
      district: self.district,
      course_id:  (self.searchable.class == Lesson) ? self.searchable.course_id.to_s : "",
      tags: self.tags,
      user_id: self.user_id,
      last_name: self.last_name,
      user_status: self.user_status,
      type: self.searchable.class == Lesson ? "lesson_type" : "course_type", 
      favorite: self.searchable.class == Lesson ? Favorite.where(favoritable_id: self.searchable_id, favoritable_type: "Lesson").count : Favorite.where(favoritable_id: self.searchable_id, favoritable_type: "Course").count
    }
  end
end
