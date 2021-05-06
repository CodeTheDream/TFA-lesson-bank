class DocumentPolicy < ApplicationPolicy
    def logged_in?
      @user.present?
    end
  
    def owner_or_admin?
        # byebug
      if @record.lesson_id.present?
        course = Course.find(@record.lesson.course_id)
        (@user&.role == 'admin') || (course&.user_id == @user.id)
        # byebug
      elsif @record.course_id.present?
        # byebug
        course = Course.find(@record.course_id)
        (@user&.role == 'admin') || (course&.user_id == @user.id)
        # byebug
      end
      # (@user&.role == 'admin') || (course&.user_id == @user.id)
    end
  
    %i(index? new? create? show?).each do |ali|
      alias_method ali, :logged_in?
    end
  
    %i(edit? update? destroy?).each do |ali|
      alias_method ali, :owner_or_admin?
    end
end