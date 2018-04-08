class Admin::WorkPolicy < AdminPolicy
  class Scope < Scope
    def resolve
      scope.all.alphabetical
    end
  end
end
