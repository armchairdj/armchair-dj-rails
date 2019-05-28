# frozen_string_literal: true

module Admin
  class WorkPolicy < Admin::BasePolicy
    alias reorder_credits? update?
  end
end
