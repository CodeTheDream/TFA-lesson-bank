FactoryBot.define do
  factory :favorite do
    user { 1 }
    favoritable_id { 1 }
    favoritable_type { "MyString" }
  end
end
