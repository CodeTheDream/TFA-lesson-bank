module SearchItemSearch
  attr_reader :query, :options

  PER_PAGE = 20

  def self.search(query:nil, options: {})
    @query = query.presence || "*"
    @options = options

    constraints = {
      page: options[:page],
      per_page: PER_PAGE
    }

    constraints[:where] = where_options
    constraints[:order] = order
    SearchItem.search(@query, constraints)
  end

  def self.where_options
    where = {}

    if @options["subject"].present?
      where["subject"] = @options["subject"]
    end

    if @options[:available_grade_levels].present? && @options[:available_grade_levels].keys[0].present?
      where["grade_level"] = @options[:available_grade_levels].keys[0]
    end

    if @options["state"].present?
      where["state"] = @options["state"]
    end

    if @options["district"].present?
      where["district"] = @options["district"]
    end

    if @options["courses"].present?
      where["type"] = "course_type"
    end

    if @options["lessons"].present?
      where["type"] = "lesson_type"
    end

    where
  end

  def self.order
   options = {}
#    if options[:sort_attribute].present?
#      order = options[:sort_order].presence || :asc
#      options[:sort_attribute] => order
#    else
#      { }
#    end
   options
  end
end
