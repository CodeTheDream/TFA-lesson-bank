class UserPolicy < ApplicationPolicy
  attr_reader :user, :record
  def initialize(user, record)
    @user = user
    @record = record
  end
  
  def logged_in?
    (@user.present?) && (@user.status == 'Approved')
  end
    
  def admin?
    ((@user.role == 'admin') || (@record&.id == @user.id)) && (@user.status == 'Approved')
  end
    
  %i(index? new? create? show?).each do |ali|
    alias_method ali, :logged_in?
  end

  %i(edit? update? destroy?).each do |ali|
    alias_method ali, :admin?
  end

end
  
