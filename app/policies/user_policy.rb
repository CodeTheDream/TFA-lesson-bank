class UserPolicy < ApplicationPolicy
  attr_reader :user, :record
  def initialize(user, record)
    @user = user
    @record = record
  end

  def logged_in_and_approved?
    @user.present? && @user.status == 'Approved'
  end

  def creator?
    @user&.role == 'creator'
  end

  def owner?
    @record&.user_id == @user.id
  end

  def admin?
    logged_in_and_approved? && @user&.role == 'admin'
  end

  def creator_or_admin?
    logged_in_and_approved? && (creator? || admin?)
  end

  def owner_and_creator_or_admin?
    creator_or_admin? && owner?
  end

  %i(edit? update? i_downloaded? show? user_courses? destroy?).each do |ali|
    alias_method ali, :logged_in_and_approved?
  end

  %i(who_downloaded?).each do |ali|
    alias_method ali, :creator_or_admin?
  end

  %i(index?).each do |ali|
    alias_method ali, :admin?
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
    
  
    
  %i(index? new? create? show? who_downloaded? ).each do |ali|
    alias_method ali, :logged_in_and_approved?
  end

  %i(index? edit? update? destroy?).each do |ali|
    alias_method ali, :admin?
  end

  %i( edit? update? destroy?).each do |ali|
    alias_method ali, :owner_and_approved?
  end

end
  
