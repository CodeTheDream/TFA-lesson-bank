class CoursePolicy < ApplicationPolicy
  def logged_in_and_approved?
    (@user.present?) && (@user.status == 'Approved')
  end

  def owner_or_creator?
    (@user&.role == 'creator') || (@record&.user_id == @user.id) 
  end

  def owner_or_admin?
    (@user&.role == 'admin') || (@record&.user_id == @user.id) 
  end

  %i(index? show? download? course_lesson_form? load_course? load_lesson? favorite? unfavorite? log? flag? unflag?).each do |ali|
    alias_method ali, :logged_in_and_approved?
  end

  %i(new? create? edit? update? destroy?).each do |ali|
    alias_method ali, :owner_or_creator?
  end

  %i(edit? update? destroy?).each do |ali|
    alias_method ali, :owner_or_admin?
  end
end
