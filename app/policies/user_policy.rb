class CoursePolicy < ApplicationPolicy
#   def logged_in?
#     @user.present?
#   end
    
#   def owner_or_admin?
#     byebug
#     (@user&.role == 'admin') || (@record&.user_id == @user.id) 
#     byebug
#   end
    
#   %i(new? create? show?).each do |ali|
#     byebug
#     alias_method ali, :logged_in?
#   end
    
#   %i(edit? update? destroy?).each do |ali|
#     byebug
#     alias_method ali, :owner_or_admin?
#   end
end
  