FactoryBot.define do
  factory :favorite do
    user { :user }
    favoritable_id { :course }
    favoritable_type { "MyString" }
  end
end
