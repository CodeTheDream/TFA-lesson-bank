class SearchItem < ApplicationRecord
  include SearchItemSearch
  belongs_to :searchable, polymorphic: true

  searchkick word_middle: [ :title, :description, :tags], merge_mappings: true

  def search_data attrs = attributes.dup
    relational = {
      title: self.title,
      description: self.description,
      subject: self.subject,
      grade_level: self.grade_level,
      state: self.state,
      district: self.district,
      course_id: self.searchable.course_id.present? ? self.searchable.course_id.to_s : "",
      tags: self.tags,
      user_id: self.user_id
    }
  end
end
