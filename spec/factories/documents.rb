FactoryBot.define do
  factory :document, class: Document do
    document { File.new("#{Rails.root}/spec/factories/railsbook.pdf") }
  end
end