class AdminPolicy < ApplicationPolicy
  def index?
    force_admin_login

    admin?
  end

  def show?
    force_admin_login

    admin?
  end

  def create?
    force_admin_login

    admin?
  end

  def update?
    force_admin_login

    admin?
  end

  def destroy?
    force_admin_login

    admin?
  end
end
