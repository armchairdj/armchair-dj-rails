# frozen_string_literal: true

class Admin::PostPolicy < Admin::BasePolicy
  class Scope < Scope
    def resolve
      if user
        if user.can_edit?
          scope
        else
          scope.where(author_id: user.id)
        end
      else
        scope.none
      end
    end
  end

  def update?
    super && (user.can_edit? || user == record.author)
  end

  def publish?
    update? && user.can_publish?
  end
end
