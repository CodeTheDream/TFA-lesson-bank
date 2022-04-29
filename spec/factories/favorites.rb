FactoryBot.define do
  factory :favorite do
    user
    favoritable_id { Course.last.id }
    favoritable_type { "MyString" }
  end
end
