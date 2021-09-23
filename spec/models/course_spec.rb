require 'rails_helper'
RSpec.describe Course, type: :model do
  describe 'Course' do
    before do
      @user = FactoryBot.create(:user)
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
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
    it "is not valid without a state" do
      @course.state = nil
      expect(@course).to_not be_valid
    end
    it "is not valid without a district" do
      @course.district = nil
      expect(@course).to_not be_valid
    end
  end
  describe "Associations" do
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag)
      @grade = Grade.create(grade_level: "11")

      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id}
      @course = Course.create(course_hash)
      hash = {course_id: @course.id, tag_id: @tag.id}
      KeyWord.find_or_create_by(hash)
      @course.grades << @grade
    end

    after do
      @user.delete
      @tag.delete
      CoursesGrade.all.delete_all
      @grade.delete
      @course.delete
    end


    it "has tags" do
      expect(@course.tags).to eq([@tag])
    end

    it "belongs to @user" do
      expect(@course.user).to eq(@user)
    end

    it "has a grade" do
      expect(@course.grades[0]).to eq(@grade)
    end
  end

  describe "methods" do
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag)
      course_hash = {title: "React", description: "React", subject: "Hooks", state: "NC", district: "02", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
      @course = Course.create(course_hash)
      hash = {course_id: @course.id, tag_id: @tag.id}
      KeyWord.find_or_create_by(hash)
    end

    after do
      @user.delete
      @tag.delete
      @course.delete
    end

    it "has a tag_list" do
      expect(@course.tag_list).to eq("MyString")
    end
  end
end
