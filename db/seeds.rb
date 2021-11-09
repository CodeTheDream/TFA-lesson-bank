# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create Users
print "Creating users"
user_hash1 = {email: 'MissBliss@JFKHS.com', role: 'teacher', first_name: 'Carrie', last_name: 'Bliss', password: '111111'}
user_hash2 = {email: 'GeorgeFeeny@JAHS.com', role: 'teacher', first_name: 'George', last_name: 'Feeny', password: '111111'}
user_admin1 = {email: 'admin1@TFA.com', role: 'admin', first_name: 'Admin1', last_name: 'TFA', password: '111111'}
user_admin2 = {email: 'admin2@TFA.com', role: 'admin', first_name: 'Admin2', last_name: 'TFA', password: '111111'}
user_hashes = []
user_hashes << user_hash1
user_hashes << user_hash2
user_hashes << user_admin1
user_hashes << user_admin2
errors = 0
success = 0
user_hashes.each do |hash|
  if User.create hash
    success += 1
    u = User.last
    u.confirm
    print '.'
  else
    errors =+ 1
    print 'x'
  end
end
puts 'done'
puts "Created #{success} users with #{errors} failures"

# create Grades
levels = %w(PRE-K K 1 2 3 4 5 6 7 8 9 10 11 12)
print "Creating grades"
errors = 0
success = 0
levels.each do |level|
  if Grade.create(grade_level: level)
    success += 1
    print '.'
  else
    errors =+ 1
    print 'x'
  end
end
print " done"
puts 'done'
puts "Created #{success} grades with #{errors} failures"

# Create Courses
user = User.find_by email: "missbliss@jfkhs.com"
print "Creating Courses"
course_hash1 = {title: "Ruby", description: "This is an introduction to the Ruby programming language.  It is intended for a student with no prior knowledge", subject: "Technology", state: "NC", district: "Wake", user_id: user.id}
course_hash2 = {title: "Rails", description: "This course is about the Rails framework.  Students must take Ruby before registering", subject: "Technology", state: "NC", district: "Wake", user_id: user.id}
course_hashes = []
course_hashes << course_hash1
course_hashes << course_hash2
errors = 0
success = 0
grade_10 = Grade.all[-3]
grade_11 = Grade.all[-2]
course_hashes.each do |hash|
  if Course.create hash
    c = Course.last
    c.grades << grade_10 if c.id % 2 == 1
    c.grades << grade_11 if c.id % 2 == 1
    c.grades << grade_11 if c.id % 2 == 0
    success += 1
    print '.'
  else
    errors =+ 1
    print 'x'
  end
end
puts 'done'
puts "Created #{success} courses with #{errors} failures"

# Create lessons
print "Creating Lessons"
ruby_course = Course.find_by title: 'Ruby'
rails_course = Course.find_by title: 'Rails'
lesson_hash1 ={title: "Variables", description: "This lesson covers how to declare and call variables in ruby.", course_id: ruby_course.id}
lesson_hash2 ={title: "Methods", description: "This lesson goes over how to define and call methods.  It will also cover class methods as well.", course_id: ruby_course.id}
lesson_hash3 ={title: "Models", description: "This lesson goes over the basics of models in the rails framework.", course_id: rails_course.id}
lesson_hash4 ={title: "Controllers", description: "This lesson covers controllers in the rails framework.", course_id: rails_course.id}

lesson_hashes = []
lesson_hashes << lesson_hash1
lesson_hashes << lesson_hash2
lesson_hashes << lesson_hash3
lesson_hashes << lesson_hash4
errors = 0
success = 0
lesson_hashes.each do |hash|
  if Lesson.create hash
    success += 1
    print '.'
  else
    errors =+ 1
    print 'x'
  end
end
puts 'done'
puts "Created #{success} lessons with #{errors} failures"

#Create course favorite and lesson favorite
user = User.find_by email: "missbliss@jfkhs.com"
print "Creating Favorites"
ruby_course = Course.find_by title: 'Ruby'
methods_lesson = Lesson.find_by title: "Methods"
fav_course_hash1 ={user_id: user.id, favoritable_id: ruby_course.id, favoritable_type: "Course"}
fav_lesson_hash1 ={user_id: user.id, favoritable_id: methods_lesson.id, favoritable_type: "Lesson"}
favorite_hashes = []
favorite_hashes << fav_course_hash1
favorite_hashes << fav_lesson_hash1
errors = 0
success = 0
favorite_hashes.each do |hash|
  if Favorite.create hash
    success += 1
    print '.'
  else
    errors =+ 1
    print 'x'
  end
end
puts 'done'
puts "Created #{success} favorites with #{errors} failures"

#Create documents
print "Creating Documents"
methods_lesson = Lesson.find_by title: "Methods"
variables_lesson = Lesson.find_by title: "Variables"
ruby_syllabus_hash = { name: "Ruby Syllabus", description: "This is a comprehensive list of requirements for the course", kind: "reference", course_id: ruby_course.id }
ruby_calendar_hash = { name: "Ruby Calendar", description: "This is a calendar for the Ruby course", kind: "reference", course_id: ruby_course.id }
methods_assessment_hash = { name: "Methods Assessment", description: "This is an assessment", kind: "evaluation", lesson_id: methods_lesson.id }
methods_handout_hash = { name: "Methods Handout", description: "This is a Handout", kind: "classwork", lesson_id: methods_lesson.id }
variables_assessment_hash = { name: "Variables Assessment", description: "This is an assessment", kind: "evaluation", lesson_id: variables_lesson.id }
variables_calendar_hash = { name: "Variables Calendar", description: "This is a calendar", kind: "reference", lesson_id: variables_lesson.id }

documents_array = [ ruby_syllabus_hash, ruby_calendar_hash, methods_assessment_hash, methods_handout_hash, variables_assessment_hash, variables_calendar_hash ]
file_array = ["public/RubyCourseDoc.pdf", "public/RubyCourseCalendar.pdf", "public/MethodsAssessment.pdf", "public/MethodsHandout.pdf", "public/VariablesPreAssessment.pdf", "public/VariablesCalendar.pdf"]
documents_hash = documents_array.zip(file_array).to_h

errors = 0
success = 0
documents_hash.keys.each do |doc|
  path = documents_hash[doc]
  file = path.split('/')[-1]
  d = ruby_course.documents.build doc
  d.file.attach(io: File.open("#{path}"), filename: "#{file}")
  if d.save
    success += 1
    print '.'
  else
    errors =+ 1
    print 'x'
  end
end
puts 'done'
puts "Created #{success} documents with #{errors} failures"


# Create Tags
print "Creating Tags"
names = %w(Ruby Programming Rails Framework Methods Models Controllers Variables)
errors = 0
success = 0
names.each do |name|
  if Tag.create name: name
    success += 1
    print '.'
  else
    errors =+ 1
    print 'x'
  end
end
puts 'done'
puts "Created #{success} tags with #{errors} failures"

# Create key_words
print "Creating Key Words"
ruby_course = Course.find_by title: 'Ruby'
rails_course = Course.find_by title: 'Rails'
variables_lesson = Lesson.find_by title: 'Variables'
methods_lesson = Lesson.find_by title: 'Methods'
models_lesson = Lesson.find_by title: 'Models'
controllers_lesson = Lesson.find_by title: 'Controllers'
ruby_tag = Tag.find_by name: 'Ruby'
programming_tag = Tag.find_by name: 'Programming'
rails_tag = Tag.find_by name: 'Rails'
framework_tag = Tag.find_by name: 'Framework'
methods_tag = Tag.find_by name: 'Methods'
models_tag = Tag.find_by name: 'Models'
controllers_tag = Tag.find_by name: 'Controllers'
variables_tag = Tag.find_by name: 'Variables'

key_word_hashes = []
key_word_hashes << { tag_id: ruby_tag.id, course_id: ruby_course.id}
key_word_hashes << { tag_id: programming_tag.id, course_id: ruby_course.id}
key_word_hashes << { tag_id: rails_tag.id, course_id: rails_course.id}
key_word_hashes << { tag_id: ruby_tag.id, course_id: rails_course.id}
key_word_hashes << { tag_id: framework_tag.id, course_id: rails_course.id}
key_word_hashes << { tag_id: methods_tag.id, lesson_id: methods_lesson.id}
key_word_hashes << { tag_id: ruby_tag.id, lesson_id: methods_lesson.id}
key_word_hashes << { tag_id: rails_tag.id, lesson_id: models_lesson.id}
key_word_hashes << { tag_id: models_tag.id, lesson_id: models_lesson.id}
key_word_hashes << { tag_id: controllers_tag.id, lesson_id: controllers_lesson.id}
key_word_hashes << { tag_id: rails_tag.id, lesson_id: controllers_lesson.id}
key_word_hashes << { tag_id: variables_tag.id, lesson_id: variables_lesson.id}
key_word_hashes << { tag_id: ruby_tag.id, lesson_id: variables_lesson.id}
errors = 0
success = 0
key_word_hashes.each do |hash|
  if KeyWord.create hash
    success += 1
    print '.'
  else
    errors =+ 1
    print 'x'
  end
end
puts 'done'
puts "Created #{success} key_words with #{errors} failures"

# Create Search Items
print "Creating Search Items"
courses = Course.all
user = User.find_by email: "missbliss@jfkhs.com"
errors = 0
success = 0
courses.each do |course|
        hash = { searchable_id: course.id, searchable_type: 'Course', title: course.title, description: course.description, subject: course.subject, grade_level: course.grades.pluck(:grade_level).join(' '), state: course.state, district: course.district, tags: course.tags.pluck(:name).join(' '), user_id: user.id}
  search_item = SearchItem.new(hash)
  if search_item.save
    course.search_item = search_item
    success += 1
    print '.'
  else
    errors =+ 1
    print 'x'
  end
  course.lessons.each do |lesson|
    hash = { searchable_id: lesson.id, searchable_type: 'Lesson', title: lesson.title, description: lesson.description, course_id: lesson.course_id, tags: lesson.tags.pluck(:name).join(' '), subject: lesson.course.subject, grade_level: lesson.course.grades.pluck(:grade_level).join(' '), user_id: user.id }
    search_item = SearchItem.new hash
    if search_item.save
      lesson.search_item = search_item
      success += 1
      print '.'
    else
      errors =+ 1
      print 'x'
    end
  end
end
SearchItem.reindex
puts 'done'
puts "Created #{success} search_items with #{errors} failures"
