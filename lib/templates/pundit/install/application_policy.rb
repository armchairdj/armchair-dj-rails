# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  def initialize(user, record)
    @user   = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def new?
    create?
  end

  def create?
    false
  end

  def edit?
    update?
  end

  def update?
    false
  end

  def destroy?
    false
  end

protected

  def can_administer?
    user.can_administer?
  end

  def owner_or_admin?
    (user.can_administer? || user == record.user)
  end

  def force_login
    raise Pundit::NotAuthenticatedError, "must be logged in" unless user
  end

  def force_admin_login
    logged_in?

    raise Pundit::NotAuthorizedError, "must be admin" unless user.admin?
  end

  def raise_unauthorized
    raise Pundit::NotAuthorizedError, "unauthorized" unless record_in_scope?
  end

  def record_in_scope?
    scope.where(id: record.id).exists?
  end
end
