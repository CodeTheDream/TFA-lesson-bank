require 'rails_helper'
RSpec.describe Course, type: :model do
  describe 'Course' do
    before do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.new(course_hash)
    end

    after do
      @user.delete
      @course.delete
    end

    it "is valid with valid attributes" do
      expect(@course).to be_valid 
    end

    it "is not valid without a title" do
      @course.title = nil
      expect(@course).to_not be_valid
    end

    it "is not valid without a description" do
      @course.description = nil
      expect(@course).to_not be_valid
    end
    it "is not valid without a @course" do
      @course.subject = nil
      expect(@course).to_not be_valid
    end
    it "is not valid without a grade_level" do
      @course.grade_level = nil
      expect(@course).to_not be_valid
    end
    it "is not valid without a state" do
      @course.state = nil
      expect(@course).to_not be_valid
    end
    it "is not valid without a district" do
      @course.district = nil
      expect(@course).to_not be_valid
    end
    it "is not valid without a start_date" do
      @course.start_date = nil
      expect(@course).to_not be_valid
    end
    it "is not valid without a end_date" do
      @course.end_date = nil
      expect(@course).to_not be_valid
    end
    it "is not valid without a created_at" do
      @course.created_at = nil
      expect(@course).to_not be_valid
    end
    it "is not valid without a updated_at" do
      @course.updated_at = nil
      expect(@course).to_not be_valid
    end
  
  end
  describe "Associations" do
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag)
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      hash = {course_id: @course.id, tag_id: @tag.id, frequency: 1}
      KeyWord.find_or_create_by(hash)
    end

    after do
      @user.delete
      @tag.delete
      @course.delete
    end


    it "has tags" do
      expect(@course.tags).to eq([@tag])
    end

    it "belongs to @user" do
      expect(@course.user).to eq(@user)
    end
  end

  describe "methods" do
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag)
      course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      hash = {course_id: @course.id, tag_id: @tag.id, frequency: 1}
      KeyWord.find_or_create_by(hash)
    end

    after do
      @user.delete
      @tag.delete
      @course.delete
    end

    it "has a tag_list" do
      expect(@course.tag_list).to eq(["MyString"])
    end
  end
end
