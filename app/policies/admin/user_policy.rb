class Admin::UserPolicy < AdminPolicy
  class Scope < Scope
    def resolve
      scope.all.alphabetical
    end
  end
end
