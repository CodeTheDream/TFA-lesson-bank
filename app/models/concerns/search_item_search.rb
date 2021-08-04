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

    if @options["grade_level"].present?
      where["grade_level"] = @options["grade_level"]
    end

    if @options["state"].present?
      where["state"] = @options["state"]
    end

    if @options["district"].present?
      where["district"] = @options["district"]
    end

    if @options["units_covered"].present?
      where["units_covered"] = @options["units_covered"]
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