FactoryBot.define do
  factory :document, class: Document do
    any_extra_field { 'its value' }
  end
  # factory :lesson_with_document do
  #   document { File.new("#{Rails.root}/spec/factories/railsbook.pdf") }
  # end
end