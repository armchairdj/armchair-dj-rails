# frozen_string_literal: true

class Admin::PostPolicy < AdminPolicy
  class Scope < Scope
    def resolve
      return scope.for_admin if user.can_edit?

      scope.for_admin.where(author_id: user.id)
    end
  end

  def update?
    super && owns_or_can_edit?
  end

  def publish?
    update? && user.can_publish?
  end

protected

  def owns_or_can_edit?
    (user.can_edit? || user == record.author)
  end

  def publisher?
    user.can_publish?
  end
end
