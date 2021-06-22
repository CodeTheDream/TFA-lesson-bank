FactoryBot.define do
  factory :user do |f|
      f.id { 100 }
      f.email  {Faker::Internet.email}
      f.role { "teacher" }
      f.created_at { Time.now }
      f.updated_at { Time.now }
      f.password { "Pa$$word1" }
      f.password_confirmation { "Pa$$word1" }
  end
end
