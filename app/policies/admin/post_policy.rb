# frozen_string_literal: true

class Admin::PostPolicy < Admin::BasePolicy
  class Scope < Scope
    def resolve
      scope.for_cms_user(user)
    end
  end

  def update?
    super && (user.can_edit? || user == record.author)
  end

  def publish?
    update? && user.can_publish?
  end

  def autosave?
    update? && record.persisted? && record.unpublished?
  end
end
