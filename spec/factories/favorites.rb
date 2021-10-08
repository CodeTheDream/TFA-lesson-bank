FactoryBot.define do
  factory :favorite do
    start { false }
    user { nil }
    favoritable_id { 1 }
    favoritable_type { "MyString" }
  end
end
