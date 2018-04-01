class WorkPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all.alphabetical
    end
  end
end
