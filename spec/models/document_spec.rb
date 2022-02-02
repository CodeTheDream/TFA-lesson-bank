require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'Document' do
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag)
      @course = FactoryBot.create(:course)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
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
    
    it "is valid with valid attributes" do
      expect(@document).to be_valid  
    end
    it "is not valid without name" do
      @document.name = nil
      expect(@document).to_not be_valid
    end
    it "is not valid without description" do
      @document.description = nil
      expect(@document).to_not be_valid
    end
    it "is not valid without kind" do
      @document.kind = nil
      expect(@document).to_not be_valid
    end
  end
  describe "Associations" do
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag)
      @course = FactoryBot.create(:course)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
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

    it "document belongs to @lesson" do
      expect(@document.lesson).to eq(@lesson)

    end

    it "document belongs to @course" do
      expect(@document.course).to eq(@course)
    end

    it "has_document" do
      expect(Document.last).to eq(@document)
    end
  end
end
