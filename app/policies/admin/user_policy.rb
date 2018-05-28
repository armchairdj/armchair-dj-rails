# frozen_string_literal: true

class Admin::UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.for_admin
    end
  end

  def index?
    logged_in_as_cms_user? && user.root?
  end

  def show?
    logged_in_as_cms_user? && user.root?
  end

  def create?
    logged_in_as_cms_user? && user.root?
  end

  def update?
    logged_in_as_cms_user? && user.root?
  end

  def destroy?
    logged_in_as_cms_user? && user.root?
  end
end
