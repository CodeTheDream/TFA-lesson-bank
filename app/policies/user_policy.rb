class UserPolicy < ApplicationPolicy
  def logged_in?
    byebug
    @record.present?

    # @user.present?
    
  end
    
  def owner_or_admin?
    byebug
    (@record.role.name == 'admin') 
    # || (@record&.user_id == @user.id) 
    # (@user&.role == 'admin') || (@record&.user_id == @user.id) 
  end
    
  %i(index? new? create? show?).each do |ali|
    byebug
    alias_method ali, :logged_in?
  end
    
  %i(index? edit? update? destroy?).each do |ali|
    byebug
    alias_method ali, :owner_or_admin?
  end
end
  