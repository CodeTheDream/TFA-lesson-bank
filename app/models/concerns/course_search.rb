module CourseSearch
  attr_reader :query, :options

  PER_PAGE = 20

  def initialize(query:nil, options: {})
    @query = query.presence || "*"
    @options = options
  end

  def search
    constraints = {
      page: options[:page],
      per_page: PER_PAGE
    }

    constraints[:where] = where
    constraints[:order] = order

    Course.search(query, constraints)
  end

  private

  def where
    where = {}
    if options[:title].present?
      where[:title] = options[:title]
    end

    if options[:description].present?
      where[:description] = options[:description]
    end

    if options[:subject].present?
      where[:subject] = options[:subject]
    end

    if options[:grade_level].present?
      where[:grade_level] = options[:grade_level]
    end

    if options[:state].present?
      where[:state] = options[:state]
    end

    if options[:district].present?
      where[:district] = options[:district]
    end

    if options[:start_date].present?
      where[:start_date] = options[:start_date]
    end

    if options[:end_date].present?
      where[:end_date] = options[:end_date]
    end

#    if options[:director_deathdate].present?
#      where[:director_death_date] = { lte: options[:director_deathdate] }
#    end

    where
  end

  def order
    #if _score isn't working try score
   { options[:sort_attribute] => '_score' }
#    if options[:sort_attribute].present?
#      order = options[:sort_order].presence || :asc
#      { options[:sort_attribute] => order }
#    else
#      { }
#    end
  end

  def search_data attrs = attributes.dup
    relational = {
      title: title,                                                                 
      description: description,                                                     
      subject: subject,                                                             
      grade_level: grade_level,                                                     
      state: state,                                                                 
      district: district,                                                           
      start_date: start_date,                                                       
      end_date: end_date      
    }

#    if director.death_date.present?
#      relational[:director_death_date] = director.death_date
#    end
    attrs.merge! relational
  end
end
