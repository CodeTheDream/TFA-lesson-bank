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
    @record&.id == @user.id
  end

  def admin?
    @user&.role == 'admin'
  end

  def owner_or_admin?
    owner? || admin?
  end

  def creator_and_owner_or_admin?
    creator? && owner? || admin?
  end

  %i(show? user_courses?).each do |ali|
    alias_method ali, :logged_in_and_approved?
  end

  %i(edit? update? destroy? i_downloaded?).each do |ali|
    alias_method ali, :logged_in_and_approved? && :owner_or_admin?
  end

  %i(who_downloaded?).each do |ali|
    alias_method ali, :logged_in_and_approved? && :creator_and_owner_or_admin?
  end

  %i(index?).each do |ali|
    alias_method ali, :logged_in_and_approved? && :admin?
  end
end
