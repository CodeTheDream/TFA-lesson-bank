FactoryBot.define do
  factory :flag do
    user { 1 }
    flagable_id { 1 }
    flagable_type { "MyString" }
  end
end