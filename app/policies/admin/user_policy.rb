# frozen_string_literal: true

module Admin
  class UserPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.for_cms_user(user)
      end
    end

    def index?
      logged_in_as_admin_or_root?
    end

    def show?
      logged_in_as_admin_or_root?
    end

    def create?
      logged_in_as_admin_or_root?
    end

    def update?
      logged_in_as_admin_or_root?
    end

    def destroy?
      logged_in_as_root?
    end
  end
end
