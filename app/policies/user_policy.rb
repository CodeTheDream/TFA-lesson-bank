class UserPolicy < ApplicationPolicy
  attr_reader :user, :record
  def initialize(user, record)
    @user = user
    @record = record
  end
  

  def logged_in?
    byebug
    @user.present?
  end
    
  def owner_or_admin?
    byebug
    (@user&.role == 'admin') #|| (@record.id == @user.id) 
  end
    
  %i(index? show?).each do |ali|
    byebug
    alias_method ali, :logged_in?
  end
    
  %i(edit? update? destroy?).each do |ali|
    byebug
    alias_method ali, :owner_or_admin?
  end
end
  