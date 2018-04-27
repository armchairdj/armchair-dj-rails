# frozen_string_literal: true

class ApplicationPolicy
  include PolicyMethods

  attr_reader :user, :record

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  def initialize(user, record)
    @user   = user
    @record = record
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  def index?
    false
  end

  def show?
    false
  end

  def new?
    create?
  end

  def create?
    false
  end

  def edit?
    update?
  end

  def update?
    false
  end

  def destroy?
    false
  end
end
