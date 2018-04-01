class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all.reverse_cron
    end
  end
end
