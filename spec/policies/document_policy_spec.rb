require 'pundit/rspec'
require 'rails_helper'
describe DocumentPolicy do
  let(:policy) { described_class }
#   index? course_index? lesson_index? new? create? show?
  %i(new? create? index? show? course_index? lesson_index?).each do |ali|
    permissions ali do
      context 'User is not logged in' do
        it 'denies access' do
          @user = nil
          expect(policy).not_to permit @user
        end
      end
      context 'User is logged in' do
        it 'grants access' do
          @user = FactoryBot.create(:user)
          expect(policy).to permit @user
        end
      end  
    end
  end
   
  %i(edit? update? destroy?).each do |ali|
    permissions ali do
    #   context 'if @record.lesson_id.present?'
    #   #     if @record.lesson_id.present?
    #     it 'denies access if it is not owner or admin and lesson_id is present' do
    #       @user = FactoryBot.create(:user, role:'admin')
    #       course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
    #       @course = Course.new(course_hash)
    #       lesson_hash = {title: "test lesson1", description: "test lesson1", 
    #         created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
    #       @lesson = Lesson.create(lesson_hash)
    #       document_hash = {name: "Doc1 for RonR", description: "Doc1 for RonR", kind: "type1", created_at: "2021-06-01 03:25:33", updated_at: "2021-06-01 03:25:33", lesson_id: @lesson.id, course_id: @course.id}
    #       @document = Document.create(document_hash)
    #       if @record.lesson_id.present?
    #         byebug
    #         @course = Course.find(@record.lesson.course_id)
    #         if @user.role == 'admin'
    #           byebug
    #           expect(policy).to permit @user
    #         elsif course&.user_id == @user.id 
    #           byebug
    #           expect(policy).to permit @user
    #         end
    #       end
    #     end

 
      context 'owner or admin' do
        it 'denies access if it is not owner or admin' do
          @user = FactoryBot.create(:user)
          @user&.role == ''
          expect(policy).not_to permit @user
        end
      end
      context 'role admin' do
        it 'allow access to admin' do
          @user = FactoryBot.create(:user, role:'admin')
          course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
          @course = Course.new(course_hash)
          lesson_hash = {title: "test lesson1", description: "test lesson1", 
            created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
          @lesson = Lesson.create(lesson_hash)
          document_hash = {name: "Doc1 for RonR", description: "Doc1 for RonR", kind: "type1", created_at: "2021-06-01 03:25:33", updated_at: "2021-06-01 03:25:33", lesson_id: nil, course_id: @course.id}
          @document = Document.create(document_hash)
          if @record.lesson_id.present?
            course = Course.find(@record.lesson.course_id)
            byebug
            expect(policy).to permit @user
          elsif
            course = Course.find(@record.course_id)
            byebug
            expect(policy).to permit @user
          end
        end
      end 
      context 'owner' do
        it 'allow access to admin' do
          @user = FactoryBot.create(:user, role:'admin')
          course_hash = {title: "React", description: "React", subject: "Hooks", grade_level: 2, state: "NC", district: "02", start_date: "2021-05-05 00:00:00", end_date: "2021-12-31 00:00:00", created_at: Time.now, updated_at: Time.now, user_id: @user.id} 
          @course = Course.new(course_hash)
          lesson_hash = {title: "test lesson1", description: "test lesson1", 
            created_at: Time.now, updated_at: Time.now, units_covered: "3",  course_id: @course.id}
          @lesson = Lesson.create(lesson_hash)
          document_hash = {name: "Doc1 for RonR", description: "Doc1 for RonR", kind: "type1", created_at: "2021-06-01 03:25:33", updated_at: "2021-06-01 03:25:33", lesson_id: @lesson.id, course_id: @course.id}
          @document = Document.create(document_hash) 
          expect(policy).to permit @user
        end
      end 
    end
  end
end

# def owner_or_admin?
#     if @record.lesson_id.present?
#       course = Course.find(@record.lesson.course_id)
#       (@user&.role == 'admin') || (course&.user_id == @user.id)
#     elsif @record.course_id.present?
#       course = Course.find(@record.course_id)
#       (@user&.role == 'admin') || (course&.user_id == @user.id)
#     end
#     # (@user&.role == 'admin') || (course&.user_id == @user.id)
#   end

#   %i(index? course_index? lesson_index? new? create? show?).each do |ali|
#     alias_method ali, :logged_in?
#   end

#   %i(edit? update? destroy?).each do |ali|
#     alias_method ali, :owner_or_admin?
#   end
