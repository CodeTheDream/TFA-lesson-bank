FactoryBot.define do
  factory :user do |f|
      f.first_name {"name"}
      f.last_name {"lastname"}
      f.status {"Approved"}
      f.email  {Faker::Internet.email}
      f.role { "creator" }
      f.created_at { Time.now }
      f.updated_at { Time.now }
      f.password { "Pa$$word1" }
      f.password_confirmation { "Pa$$word1" }
  end

end
