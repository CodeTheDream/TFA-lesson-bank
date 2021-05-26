FactoryBot.define do
  factory :user do |f|
      f.id { 1 }
      f.email  {Faker::Internet.email}
      f.role { "teacher" }
      f.created_at { 2021-05-05 }
      f.updated_at { 2021-05-05 }
      f.password { "Pa$$word1" }
  end
end
