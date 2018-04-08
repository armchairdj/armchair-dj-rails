class WorkPolicy < PublicPolicy
  class Scope < Scope
    def resolve
      scope.joins(:posts).alphabetical
    end
  end
end
