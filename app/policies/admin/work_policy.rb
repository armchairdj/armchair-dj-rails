# frozen_string_literal: true

class Admin::WorkPolicy < Admin::BasePolicy
  alias_method :reorder_credits?, :update?
end
