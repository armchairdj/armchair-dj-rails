class CreatorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all.alphabetical
    end
  end
end
