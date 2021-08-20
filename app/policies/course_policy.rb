class CoursePolicy < ApplicationPolicy
  def logged_in?
    @user.present?
  end

  def owner_or_admin?
    (@user&.role == 'admin') || (@record&.user_id == @user.id) 
  end

  %i(index? new? create? show? download? course_lesson_form? load_course? load_lesson?).each do |ali|
    alias_method ali, :logged_in?
  end

  %i(edit? update? destroy?).each do |ali|
    alias_method ali, :owner_or_admin?
  end
end
