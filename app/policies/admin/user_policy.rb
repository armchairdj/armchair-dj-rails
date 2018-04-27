# frozen_string_literal: true

class Admin::UserPolicy < AdminPolicy
  class Scope < Scope
    def resolve
      scope.for_admin
    end
  end
end
