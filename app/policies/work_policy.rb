class WorkPolicy < CrudPolicy
  class Scope < Scope
    def resolve
      scope.all.alphabetical
    end
  end
end
