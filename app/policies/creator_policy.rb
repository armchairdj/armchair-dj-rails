class CreatorPolicy < AdminPolicy
  class Scope < Scope
    def resolve
      scope.all.alphabetical.with_counts
    end
  end
end
