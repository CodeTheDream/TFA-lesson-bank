class UserPolicy < ApplicationPolicy
  attr_reader :user, :record
  def initialize(user, record)
    @user = user
    @record = record
    byebug
  end

  def logged_in?
    @user.present?
  end
    
  def owner_or_admin?
  #   p " ========>#{@record.name} ========="
  #  byebug
    (@user.role == 'admin') || (@record&.id == @user.id)
   byebug 
  end
    
  %i(index? new? create? show?).each do |ali|
    alias_method ali, :logged_in?
  end
    
  %i(edit? update? destroy?).each do |ali|
    alias_method ali, :owner_or_admin?
  end
end
  