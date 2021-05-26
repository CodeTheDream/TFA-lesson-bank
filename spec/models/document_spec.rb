require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'Document' do
    subject { Document.new(id: 3, name: "new doc lesson1", description: "new doc lesson1", kind: "type new doc lesson1", created_at: "2021-05-19 21:44:53", updated_at: "2021-05-19 21:46:01", lesson_id: 8, course_id: 4)
              Course.new(id: 4, title: "test", description: "test", subject: "test", grade_level: 3, state: "test", district: "test", start_date: "2021-05-19 00:00:00", end_date: "2021-05-19 00:00:00", created_at: "2021-05-19 21:08:44", updated_at: "2021-05-19 21:08:53", user_id: 1)
              Lesson.new(id: 8, title: "test lesson1", description: "test lesson1", created_at: "2021-05-19 21:44:01", updated_at: "2021-05-19 21:44:01", units_covered: "3", course_id: 4)
              User.new(id: 1, email: "adi_111@icloud.com", role: "teacher", created_at: "2021-05-05 07:06:27", updated_at: "2021-05-05 07:08:29", password: "Pa$$word1")}
    it "is valid with valid attributes" do
      expect(subject).to be_valid    
    end
  end
  describe "Associations" do
    it { should belong_to(:course).optional }
    it { should belong_to(:lesson).optional }
    # it { should have_one(:document) }
 end
  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a description" do
    subject.description = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a kind" do
    subject.kind = nil
    expect(subject).to_not be_valid
  end
end


