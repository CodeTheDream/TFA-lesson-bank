module TagList
  def tag_list
    self.tags.collect do |tag|
    tag.name
    end.join(", ")
  end

  def tag_list=(input_tag_names)
    # find out what kind of object owns these tags
    is_course = self.kind_of?(Course)
    object = self
    # we need to dereference or delete tags in a way that updating tags does not effect other courses or lessons
    if self.tags.any?
      self.tags.each do |tag|
	key_word = is_course ? KeyWord.find_by(course_id: object.id, tag_id: tag.id) : KeyWord.find_by(lesson_id: object.id, tag_id: tag.id)
        # see if tag belogs to any other courses or lessons
        # if yes - delete association, if not delete the tag
        # byebug
        (tag.lessons.count + tag.courses.count) > 1 ? key_word.delete : tag.delete
      end
    end
    # create tags and/or associations through key_words for all values passed in
    self.reload
    tag_names = input_tag_names.collect{|t| t.strip.downcase}.uniq
    tag_names = tag_names.reject {|x| x == ""}
    new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
    self.tags = new_or_found_tags.reject {|x| self.tags.include? x}
  end
end
