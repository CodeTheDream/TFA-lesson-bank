module TagList
  def tag_list
    self.tags.collect do |tag|
    tag.name
    end.join(", ")
  end
  def tag_list=(tags)
    tag_names = tags.collect{|s| s.strip.downcase}.uniq
    new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
    self.tags = new_or_found_tags
  end
    
end
