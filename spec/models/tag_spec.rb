require 'rails_helper'
RSpec.describe Tag, type: :model do
  describe 'Tags' do
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag) #creates "Tag"
      @tag2 = FactoryBot.create(:tag) #creates "Tag2"
      @course = FactoryBot.create(:course)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now,  course_id: @course.id}
      @lesson = Lesson.create(lesson_hash)
      hash = {course_id: @course.id, lesson_id: @lesson.id, tag_id: @tag.id}
      KeyWord.find_or_create_by(hash)
      hash2 = {course_id: @course.id, lesson_id: @lesson.id, tag_id: @tag2.id}
      KeyWord.find_or_create_by(hash2)
  end
    after do
      @user.delete
      @tag.delete
      @tag2.delete
      KeyWord.all.delete_all
      @lesson.delete
      @course.delete
    end
    it 'course can have multiple tags' do
      expect(@course.tags.count).to eq(2) #works
    end
    it "course has tags" do
      expect(@course.tags).to eq([@tag, @tag2])
    end
    it 'lesson can have multiple tags' do
      expect(@lesson.tags.count).to eq(2) #works
    end
    it "lesson has tags" do
      expect(@lesson.tags).to eq([@tag, @tag2])
    end
    it "tag has keywords" do
      expect(@tag2.key_words).to eq([KeyWord.last])
    end
  end
end

