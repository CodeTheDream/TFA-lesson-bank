require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'Lesson' do
    before do
      @user = FactoryBot.create(:user)
      @course = FactoryBot.create(:course)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, units_covered: "3", course_id: @course.id}
      @lesson = Lesson.new(lesson_hash)
      @document = Factory.create(:document)
      # let!(:document) { create(
      #   :document, lesson: lesson, title: "Document",
      #   size: 1, lesson_id: 1) }
    end

    after do
      @user.delete
      @course.delete
      @lesson.delete
    end
    it "is valid with valid attributes" do
      expect(@lesson).to be_valid 
    end
    it "is not valid without a title" do
      @lesson.title = nil
      expect(@lesson).to_not be_valid
    end
    it "is not valid without a title" do
      @lesson.description = nil
      expect(@lesson).to_not be_valid
    end
    it "is not valid without a title" do
      @lesson.units_covered  = nil
      expect(@lesson).to_not be_valid
    end
  end

  describe "Associations" do
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag)
      @course = FactoryBot.create(:course)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        # tags: @tag.id, ?
        created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
      # ?tags
      @lesson = Lesson.create(lesson_hash)
      hash = {course_id: @course.id, lesson_id: @lesson.id, tag_id: @tag.id, frequency: 1}
      KeyWord.find_or_create_by(hash)
    end
    after do
      @user.delete
      @tag.delete
      KeyWord.all.delete_all
      @lesson.delete
      @course.delete
      
    end
    it "has tags" do
      expect(@lesson.tags).to eq([@tag])
    end
 
    it "course belongs to @user" do
      expect(@course.user).to eq(@user)
      # byebug
    end

    it "lesson belongs to @course" do
      expect(@lesson.course).to eq(@course)
    end
  end

  describe "methods" do
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag)
      @course = FactoryBot.create(:course)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        # tags: @tag.id, ?
        created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
      # ?tags
      @lesson = Lesson.create(lesson_hash)
      hash = {course_id: @course.id, lesson_id: @lesson.id, tag_id: @tag.id, frequency: 1}
      KeyWord.find_or_create_by(hash)
      # byebug
    end

    after do
      @user.delete
      @tag.delete
      KeyWord.all.delete_all
      @lesson.delete
      @course.delete
    end

    it "has a tag_list" do
      expect(@course.tag_list).to eq(["MyString"])
    end
  end

end