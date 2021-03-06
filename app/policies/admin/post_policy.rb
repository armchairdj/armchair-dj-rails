# frozen_string_literal: true

module Admin
  class PostPolicy < Admin::BasePolicy
    class Scope < Scope
      def resolve
        scope.for_cms_user(user)
      end
    end

    def update?
      super && (user.can_edit? || user.id == record.author_id)
    end

    def publish?
      update? && user.can_publish?
    end

    def autosave?
      update? && record.unpublished?
    end

    def preview?
      show?
    end
  end
end
