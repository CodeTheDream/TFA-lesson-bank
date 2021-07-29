require 'rails_helper'
RSpec.describe KeyWord, type: :model do
  describe 'KeyWord' do
    before do
      @user = FactoryBot.create(:user)
      @course = FactoryBot.create(:course)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, units_covered: "3", course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
      @tag = Tag.create(name: 't1')
      @tag2 = Tag.create(name: 't2')
      course_keyword_hash = {tag_id: @tag.id, course_id: @course.id, frequency: nil, 
        created_at: Time.now, updated_at: Time.now, lesson_id: nil}
      course_keyword_hash2 = {tag_id: @tag2.id, course_id: @course.id, frequency: nil, 
          created_at: Time.now, updated_at: Time.now, lesson_id: nil}
      @keyword_course = KeyWord.create(course_keyword_hash)
      @keyword_course2 = KeyWord.create(course_keyword_hash2)
      lesson_keyword_hash = {tag_id: @tag.id, course_id: nil, frequency: nil, 
        created_at: Time.now, updated_at: Time.now, lesson_id: @lesson.id}
      @keyword_lesson = KeyWord.create(lesson_keyword_hash)
    end #end before
    
    after do
      @user.delete
      @tag.delete
      KeyWord.all.delete_all
      @lesson.delete
      @course.delete
    end #end after

    it "should not create two tags with the same name" do
      #t1 is associated to one course and one lesson, but we just have one record in tag
      expect {@tag.count == 1}  
    end

    it "should not decrement the count of tags by 1" do
      expect{@keyword_lesson.delete}.to_not change(Tag, :count)
    end

    it "should delete the keyword associated to the lesson" do
      @tag.key_words.count 
      # @tag is associated to one course and one lesson
      # we will make sure we delete @tag associated to lesson
      expect { @tag.count.should ==  1}
      @tag.key_words.count 
      expect{@keyword_lesson.delete}.to change(KeyWord, :count)
    end

  end #end describe
  describe "Associations" do
    it { should belong_to(:tag).without_validating_presence }
    it { should belong_to(:course).without_validating_presence }
    it { should belong_to(:lesson).without_validating_presence }
  end #end Associations
end #final end

