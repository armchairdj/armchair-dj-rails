# frozen_string_literal: true

module Admin
  class PlaylistPolicy < Admin::BasePolicy
    alias reorder_tracks? update?
  end
end
