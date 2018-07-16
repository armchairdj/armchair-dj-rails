# frozen_string_literal: true

class Admin::UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if user.root?

      scope.where("users.role <= ?", user.raw_role).where.not(id: user.id)
    end
  end

  def index?
    logged_in_as_cms_user? && user.can_administer?
  end

  def show?
    logged_in_as_cms_user? && user.can_administer?
  end

  def create?
    logged_in_as_cms_user? && user.can_administer?
  end

  def update?
    logged_in_as_cms_user? && user.can_administer?
  end

  def destroy?
    logged_in_as_cms_user? && user.can_destroy?
  end
end
