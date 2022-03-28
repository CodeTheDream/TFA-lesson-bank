class DocumentPolicy < ApplicationPolicy
    def logged_in?
      @user.present?
    end
  
    def owner_or_admin?
      if @record.lesson_id.present?
        course = Course.find(@record.lesson.course_id)
        (@user&.role == 'admin') || (course&.user_id == @user.id)
      elsif @record.course_id.present?
        course = Course.find(@record.course_id)
        (@user&.role == 'admin') || (course&.user_id == @user.id)
      end
      # (@user&.role == 'admin') || (course&.user_id == @user.id)
    end
  
    %i(index? course_index? lesson_index? new? create? show? load_course? load_lesson? favorite? unfavorite? log? flag? unflag?).each do |ali|
      alias_method ali, :logged_in?
    end
  
    %i(edit? update? destroy?).each do |ali|
      alias_method ali, :owner_or_admin?
    end
end
