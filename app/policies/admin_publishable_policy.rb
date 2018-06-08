# frozen_string_literal: true

class AdminPublishablePolicy < AdminPolicy
  class Scope < Scope
    def resolve
      return scope.for_admin if user.can_edit?

      scope.for_admin.where(author_id: user.id)
    end
  end

  def update?
    super && (user.can_edit? || user == record.author)
  end

  def publish?
    update? && user.can_publish?
  end
end
