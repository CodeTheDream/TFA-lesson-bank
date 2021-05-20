require 'rails_helper'
RSpec.describe Course, type: :model do
  describe 'Course' do
    subject { Course.new(id: 1, title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: "2021-05-05 07:09:07", updated_at: "2021-05-05 07:09:07", user_id: 1)
              User.new(id: 1, email: "adi_111@icloud.com", role: "teacher", created_at: "2021-05-05 07:06:27", updated_at: "2021-05-05 07:08:29", password: "Pa$$word1")} 
    it "is valid with valid attributes" do
      expect(subject).to be_valid    
    end
  end
  describe "Associations" do
    it { should belong_to(:user) }
    it { should have_many(:lessons) }
    it { should have_many(:documents) }
  end
  it "is not valid without a title" do
    subject.title = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a description" do
    subject.description = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a subject" do
    subject.subject = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a grade_level" do
    subject.grade_level = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a state" do
    subject.state = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a district" do
    subject.district = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a start_date" do
    subject.start_date = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a end_date" do
    subject.end_date = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a created_at" do
    subject.created_at = nil
    expect(subject).to_not be_valid
  end
  it "is not valid without a updated_at" do
    subject.updated_at = nil
    expect(subject).to_not be_valid
  end

end

