require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'Lesson' do
    subject { Lesson.new(id: 8, title: "test lesson1", description: "test lesson1", created_at: "2021-05-19 21:44:01", updated_at: "2021-05-19 21:44:01", units_covered: "3", course_id: 4)
              Course.new(id: 4, title: "test", description: "test", subject: "test", grade_level: 3, state: "test", district: "test", start_date: "2021-05-19 00:00:00", end_date: "2021-05-19 00:00:00", created_at: "2021-05-19 21:08:44", updated_at: "2021-05-19 21:08:53", user_id: 1)
              User.new(id: 1, email: "adi_111@icloud.com", role: "teacher", created_at: "2021-05-05 07:06:27", updated_at: "2021-05-05 07:08:29", password: "Pa$$word1")}
    it "is valid with valid attributes" do
      expect(subject).to be_valid    
    end
  end
  describe "Associations" do
    it { should belong_to(:course) }
    it { should have_many(:documents) }
    it { should have_many(:tagginglessons) }
    it { should have_many(:tags).through(:tagginglessons)  }
  end
  it "is not valid without a title" do
    subject.title = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a description" do
    subject.description = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a units_covered" do
    subject.units_covered = nil
    expect(subject).to_not be_valid
  end

  
  
end
#pending test
 # def tag_list
  #   self.tags.collect do |tag|
  #   tag.name
  #   end.join(", ")
  # end
#   def tag_list=(tags_string)
#     tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
#     new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
#     self.tags = new_or_found_tags
#   end