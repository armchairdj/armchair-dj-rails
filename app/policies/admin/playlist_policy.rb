# frozen_string_literal: true

class Admin::PlaylistPolicy < Admin::BasePolicy
  alias reorder_tracks? update?
end
