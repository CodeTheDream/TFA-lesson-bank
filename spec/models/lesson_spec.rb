require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'Lesson' do
    before do
      @user = FactoryBot.create(:user)
      @course = FactoryBot.create(:course)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, course_id: @course.id}
        @lesson = Lesson.create(lesson_hash)
    end

    after do
      @user.delete
      @lesson.delete
      @course.delete
    end
    it "is valid with valid attributes" do
      expect(@lesson).to be_valid 
    end
    it "is not valid without title" do
      @lesson.title = nil
      expect(@lesson).to_not be_valid
    end
    it "is not valid without description" do
      @lesson.description = nil
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
        created_at: Time.now, updated_at: Time.now, course_id: @course.id}
      # ?tags
      @lesson = Lesson.create(lesson_hash)
      hash = {course_id: @course.id, lesson_id: @lesson.id, tag_id: @tag.id}
      KeyWord.find_or_create_by(hash)
      # @document = FactoryBot.create(:document)
      document_hash = {name: "Doc1 for RonR", description: "Doc1 for RonR", kind: "type1", created_at: "2021-06-01 03:25:33", updated_at: "2021-06-01 03:25:33", lesson_id: @lesson.id, course_id: @course.id}
      @document = Document.create(document_hash) 
    end
    after do
      @user.delete
      @tag.delete
      KeyWord.all.delete_all
      @document.delete
      @lesson.delete
      @course.delete
    end
    it "has tags" do
      expect(@lesson.tags).to eq([@tag])
    end
     

    it "course belongs to @user" do
      expect(@course.user).to eq(@user)
    end

    it "lesson belongs to @course" do
      expect(@lesson.course).to eq(@course)
    end

    it "lesson_with_document" do
      expect(Lesson.last.documents).to eq([@document])
    end

  end

  describe "methods" do
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag)
      @course = FactoryBot.create(:course)
      lesson_hash = {id: 1, title: "test lesson1", description: "test lesson1", 
        # tags: @tag.id, ?
        created_at: Time.now, updated_at: Time.now, course_id: @course.id}
      # ?tags
      @lesson = Lesson.create(lesson_hash)
      hash = {course_id: @course.id, lesson_id: @lesson.id, tag_id: @tag.id}
      KeyWord.find_or_create_by(hash)
      # @document = FactoryBot.create(:document)
      document_hash = {name: "Doc1 for RonR", description: "Doc1 for RonR", kind: "type1", created_at: "2021-06-01 03:25:33", updated_at: "2021-06-01 03:25:33", lesson_id: @lesson.id, course_id: @course.id}
      @document = Document.create(document_hash)
    end

    after do
      @user.delete
      @tag.delete
      KeyWord.all.delete_all
      @document.delete
      @lesson.delete
      @course.delete
    end

    it "has a tag_list" do
      expect(@course.tag_list).to eq("MyString")
    end
  end
end
