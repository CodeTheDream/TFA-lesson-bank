FactoryBot.define do
  factory :flag do
    user { :user }
    flagable_id { :course }
    flagable_type { "MyString" }
  end
end
