class CoursePolicy < ApplicationPolicy
  def logged_in_and_approved?
    (@user.present?) && (@user.status == 'Approved')
  end

  # def owner_or_admin?
  #   (@user&.role == 'admin') || (@record&.user_id == @user.id) 
  # end

  def admin?
    (@user&.role == 'admin') 
  end

  # def owner_and_approved?
  #  @user.status == 'Approved'
  # end 

  def owner_and_approved?
    (@course.record&.id == @user.id) && (@user.status == 'Approved')
  end 

  %i(new? create? show? download? course_lesson_form? load_course? load_lesson? favorite? unfavorite? log? flag? unflag?).each do |ali|
    alias_method ali, :logged_in_and_approved?
  end

  %i(index? edit? update? destroy?).each do |ali|
    alias_method ali, :admin?
  end

  %i( edit? update? destroy?).each do |ali|
    alias_method ali, :owner_and_approved?
  end
  

  
end
