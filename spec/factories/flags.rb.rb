FactoryBot.define do
  factory :flag do
    user
    flagable_id { Course.last.id }
    flagable_type { "MyString" }
  end
end
