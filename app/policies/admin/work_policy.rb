# frozen_string_literal: true

class Admin::WorkPolicy < Admin::BasePolicy
  alias reorder_credits? update?
end
