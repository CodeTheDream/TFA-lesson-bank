FactoryBot.define do
  factory :document, class: Document do
    any_extra_field { 'its value' }
  end
end