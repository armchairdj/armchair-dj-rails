class AdminPolicy < ApplicationPolicy
  def index?
    logged_in_as_admin?
  end

  def show?
    logged_in_as_admin?
  end

  def create?
    logged_in_as_admin?
  end

  def update?
    logged_in_as_admin?
  end

  def destroy?
    logged_in_as_admin?
  end
end
