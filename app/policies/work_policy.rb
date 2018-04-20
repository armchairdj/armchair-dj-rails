class WorkPolicy < PublicPolicy
  class Scope < Scope
    def resolve
      scope.for_site
    end
  end
end
