class LessonPolicy < ApplicationPolicy
    def logged_in?
      @user.present?
    end
  
    # def owner_or_admin?
    #   (@user&.role == 'admin') || (@record&.user_id == @user.id) 
    # end
    def admin?
      (@user&.role == 'admin') 
    end
    def owner_and_approved?
      (@record&.user_id == @user.id) && (@user.status == 'Approved')
    end 
  
    %i(new? create? show? download? favorite? unfavorite? flag? unflag?).each do |ali|
      alias_method ali, :logged_in?
    end

    %i(index? edit? update? destroy?).each do |ali|
      alias_method ali, :admin?
    end
  
    %i(edit? update? destroy?).each do |ali|
      alias_method ali, :owner_and_approved?
    end

end
