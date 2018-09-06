# frozen_string_literal: true

class Admin::PlaylistPolicy < Admin::BasePolicy
  alias_method :reorder_tracks?, :update?
end
