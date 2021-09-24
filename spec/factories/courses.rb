require 'faker'
FactoryBot.define do
  factory :course do |f|
    f.id { 100 }
    f.title  { "title" }
    f.description { "description" }
    f.subject { "subject" }
    f.state { "CA" }
    f.district { "01" }
    f.user_id { 1000 }
    
  end
end

