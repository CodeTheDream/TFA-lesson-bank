module SearchItemSearch
  attr_reader :query, :options

  PER_PAGE = 18

  def self.search(query:nil, options: {}, current_user:nil)
    @query = query.presence || "*"
    @options = options
    @current_user = current_user if current_user.present?
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

    if @options["state"].present?
      where["state"] = @options["state"]
    end

    if @options["district"].present?
      where["district"] = @options["district"]
    end

    if @options["courses"].present? && !@options["lessons"].present?
      where["type"] = "course_type"
    end

    if @options["lessons"].present? && !@options["courses"].present?
      where["type"] = "lesson_type"
    end

    if @options["selected_grades"].present?
      where["grade_level"] = @options["selected_grades"]
    end

    if @options["mycontent"].present? && @options["mycontent"] == "true"
      where["user_id"] = @current_user.id
    elsif @current_user.role != "admin"
      where["flagged"] = "false"
    end

    if @options["favorites"].present? && @options["favorites"] == "true"
      where["favorited_by"] = @current_user.id
    end

    where["user_status"] = "Approved"

    where
  end

  def self.order
    options = {}
    if @options["admin_view"].present? && @options["admin_view"] == "true"
      options[:flagged] = "desc"
    else
      options[:favorited] = "desc"
    end
    options
  end
end
