require 'faker'
FactoryBot.define do
  factory :course do |f|
    f.id { 1 }
    f.title  { "title" }
    f.description { "description" }
    f.subject { "subject" }
    f.grade_level { 1 }
    f.state { "CA" }
    f.district { "01" }
    f.start_date { Time.now }
    f.end_date { Time.now }
    f.user_id { 1 }
    
  end
end

