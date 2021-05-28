require 'rails_helper'

RSpec.describe Lesson, type: :model do
  describe 'Lesson' do
    before do
      @user = FactoryBot.create(:user)
      @course = FactoryBot.create(:course)
      lesson_hash = {title: "test lesson1", description: "test lesson1", 
        created_at: Time.now, updated_at: Time.now, units_covered: "3", course_id: @course.id}
      @lesson = Lesson.new(lesson_hash)
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
      # @user.delete
      # @tag.delete
      # @course.delete
      # @lesson.delete
      # @key_words.delete
    end
    it "has tags" do
      expect(@lesson.tags).to eq([@tag])
    end
    # it "has documment" do
    #   attach_file 'document',
    #   File.new("#{Rails.root}/spec/factories/railsbook.pdf")
    #   byebug
    #   expect(Lesson.documments).to eq 'railsbook.pdf'
    #   byebug
    # end
      # after(:each) do
      #   attach_file 'Form', @driver.save_screenshot('page.png')
      # end
      # let(:documents) {Rack::Test::UploadedFile.new("#{Rails.root}/spec/factories/railsbook.pdf")}
      # click_button 'Sign up'
      # attach_file("Upload Your PDF File", Rails.root + "spec/factories/railsbook.pdf")
    

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

    # after do
    #   @user.delete
    #   @tag.delete
    #   @course.delete
    # end

    it "has a tag_list" do
      expect(@course.tag_list).to eq(["MyString"])
    end
  end

end