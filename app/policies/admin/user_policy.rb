# frozen_string_literal: true


class Admin::UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.editable_by(user)
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
