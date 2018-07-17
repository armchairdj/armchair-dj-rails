# frozen_string_literal: true

class Admin::PostPolicy < Admin::BasePolicy
  class Scope < Scope
    def resolve
      user ? scope.for_user(user) : scope.none
    end
  end

  def update?
    super && (user.can_edit? || user == record.author)
  end

  def publish?
    update? && user.can_publish?
  end
end
