class CommentPolicy < ApplicationPolicy
  def logged_in_and_approved?
    @user.present? && @user.status == 'Approved'
  end

  def owner?
    @record&.user_id == @user.id 
  end
  
  def creator?
    @user&.role == 'creator' 
  end

  def admin?
    logged_in_and_approved? && @user&.role == 'admin' 
  end

  def creator_and_owner?
    logged_in_and_approved? && creator? && owner?
  end

  def owner_and_creator_or_admin?
    creator_and_owner? || admin?
  end

  %i(create?).each do |ali|
    alias_method ali, :logged_in_and_approved?
  end

  %i(destroy?).each do |ali|
    alias_method ali, :owner_and_creator_or_admin?
  end
end
