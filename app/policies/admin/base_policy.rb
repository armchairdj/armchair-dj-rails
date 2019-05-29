# frozen_string_literal: true

module Admin
  class BasePolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope.all
      end
    end

    def index?
      logged_in_as_cms_user?
    end

    def show?
      logged_in_as_cms_user?
    end

    def create?
      logged_in_as_cms_user?
    end

    def update?
      logged_in_as_cms_user?
    end

    def destroy?
      logged_in_as_cms_user? && user.can_destroy?
    end
  end
end
