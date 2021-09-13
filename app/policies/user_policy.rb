class UserPolicy < ApplicationPolicy
  attr_reader :user, :record
  def initialize(user, record)
    @user = user
    @record = record
  end

  def logged_in?
    @user.present?
  end
    
  def owner_or_admin?
  #   p " ========>#{@record.name} ========="
   byebug
    ret = (@user.role == 'admin') #|| (@record&.id == @user.id)
   byebug 
    ret
  end
    
  %i(index? new? create? show?).each do |ali|
    byebug
    alias_method ali, :logged_in?
  end

  %i(edit? update? destroy?).each do |ali|
    byebug
    alias_method ali, :owner_or_admin?
  end
end
  