# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
levels = %w(PRE-K K 1 2 3 4 5 6 7 8 9 10 11 12)
print "Creating grades"
levels.each do |level|
  if Grade.create(grade_level: level)
    print '.'
  else
    print 'x'
  end
end
print " done"
puts ''
