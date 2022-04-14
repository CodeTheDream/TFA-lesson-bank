class UserPolicy < ApplicationPolicy
  attr_reader :user, :record
  def initialize(user, record)
    @user = user
    @record = record
  end
  def admin?
    (@user&.role == 'admin') 
  end

  def owner_and_approved?
    (@record&.id == @user.id) && (@user.status == 'Approved')
  end 

  def logged_in_and_approved?
    (@user.present?) && (@user.status == 'Approved')
  end
    
  
    
  %i(index? new? create? show? who_downloaded? i_downloaded?).each do |ali|
    alias_method ali, :logged_in_and_approved?
  end

  %i(index? edit? update? destroy?).each do |ali|
    alias_method ali, :admin?
  end

  %i( edit? update? destroy?).each do |ali|
    alias_method ali, :owner_and_approved?
  end

end
  
