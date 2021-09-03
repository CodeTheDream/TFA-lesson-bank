class RolePolicy < ApplicationPolicy
  attr_reader :current_user
 
  def initialize(current_user)
    byebug
    @user = current_user
    byebug
  end
  ​
    def logged_in?
      byebug
    #   @record.present?
  
      @user.present?
      byebug
    end
      
    def owner_or_admin?
      byebug
    #   (@record.role == 'admin') || (@record&.user_id == @user.id) 
      (@user&.role == 'admin') || (@record&.user_id == @user.id) 
      byebug
    end
      
    %i(index? new? create? show?).each do |ali|
      byebug
      alias_method ali, :logged_in?
      byebug
    end
      
    %i(index? edit? update? destroy?).each do |ali|
      byebug
      alias_method ali, :owner_or_admin?
      byebug
    end
  end
    