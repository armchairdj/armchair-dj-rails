# frozen_string_literal: true

class UserPolicy < PublicPolicy
  class Scope < Scope
    def resolve
      scope.for_site
    end
  end
end
