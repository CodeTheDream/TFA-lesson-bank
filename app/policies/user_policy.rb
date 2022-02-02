class UserPolicy < ApplicationPolicy
  attr_reader :user, :record
  def initialize(user, record)
    @user = user
    @record = record
  end
  
  def logged_in_and_approved?
    (@user.present?) && (@user.status == 'Approved')
  end
    
  def admin_or_owner_and_approved?
    ((@user.role == 'admin') || (@record&.id == @user.id)) && (@user.status == 'Approved')
  end
    
  %i(index? new? create? show? who_downloaded? i_downloaded?).each do |ali|
    alias_method ali, :logged_in_and_approved?
  end

  %i(edit? update? destroy?).each do |ali|
    alias_method ali, :admin_or_owner_and_approved?
  end

end
  
