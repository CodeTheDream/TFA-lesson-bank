module LessonSearch
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
    Course.search(@query, constraints)
  end

  def self.where_options
    where = {}

    if @options[“title”].present?
      where["title"] = @options["title"]
    end

    if @options[“description”].present?
      where["description"] = @options["description"]
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