class UserPolicy < ApplicationPolicy
  attr_reader :user, :record
  def initialize(user, record)
    @user = user
    @record = record
  end

  def logged_in?
    @user.present?
  end
    
  def admin?
  #   p " ========>#{@record.name} ========="
   byebug
    ret = (@user.role == 'admin') #|| (@record&.id == @user.id)
   byebug 
    ret
  end

  def owner?
    #   p " ========>#{@record.name} ========="
     byebug
      ret2 = (@record&.id == @user.id)
     byebug 
      ret2
    end
    
  %i(index? new? create? show?).each do |ali|
    # byebug
    alias_method ali, :logged_in?
  end

  %i(edit? update? destroy?).each do |ali|
    # byebug
    alias_method ali, :admin?
  end

  %i(edit? update?).each do |ali|
    # byebug
    alias_method ali, :owner?
  end
end
  