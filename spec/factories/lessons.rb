FactoryBot.define do
  factory :lesson do |f|
    f.title { "test lesson1" }
    f.description { "description" }
    f.tags { "t1" }
    f.created_at { 2021-05-05 }
    f.updated_at { 2021-05-05 }
    f.units_covered { "3" }
    f.course_id { 1 }
    f.document { File.new("#{Rails.root}/spec/factories/railsbook.pdf") }
  end
end
