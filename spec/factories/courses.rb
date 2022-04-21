require 'faker'
FactoryBot.define do
  factory :course do |f|
    f.title  { "title" }
    f.description { "description" }
    f.subject { "subject" }
    f.state { "CA" }
    f.district { "01" }
    user
  end
end

