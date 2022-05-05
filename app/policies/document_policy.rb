class DocumentPolicy < ApplicationPolicy
  def logged_in_and_approved?
    @user.present? && @user.status == 'Approved'
  end

  def creator?
    @user&.role == 'creator'
  end

  def owner?
    if @record.lesson_id.present?
      record_creator = Document.find(@record.id).lesson.course.user
    elsif @record.course_id.present?
      record_creator = Document.find(@record.id).course.user
    end
      record_creator.id == @user.id
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

  %i(show?).each do |ali|
    alias_method ali, :logged_in_and_approved?
  end

  %i(create?).each do |ali|
    alias_method ali, :creator_or_admin?
  end

  %i(update? destroy?).each do |ali|
    alias_method ali, :owner_and_creator_or_admin?
  end
end
