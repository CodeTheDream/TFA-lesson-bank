class CoursePolicy < ApplicationPolicy
  def logged_in_and_approved?
    (@user.present?) && (@user.status == 'Approved')
  end

  def owner_or_admin?
    (@user&.role == 'admin') || (@record&.user_id == @user.id) 
  end

  %i(index? new? create? show? download? course_lesson_form? load_course? load_lesson? favorite? unfavorite?).each do |ali|
    alias_method ali, :logged_in_and_approved?
  end

  %i(edit? update? destroy?).each do |ali|
    alias_method ali, :owner_or_admin?
  end
end
