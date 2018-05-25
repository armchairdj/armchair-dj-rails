# frozen_string_literal: true

class PublicPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.for_site
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end
end
