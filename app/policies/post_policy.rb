# frozen_string_literal: true

class PostPolicy < PublicPolicy
  class Scope < Scope
    def resolve
      scope.for_site
    end
  end
end
