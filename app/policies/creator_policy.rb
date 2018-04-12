class CreatorPolicy < PublicPolicy
  class Scope < Scope
    def resolve
      scope.includes(:posts).alphabetical
    end
  end
end
