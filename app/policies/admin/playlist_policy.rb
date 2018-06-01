# frozen_string_literal: true

class Admin::PlaylistPolicy < AdminPolicy
  def reorder_playlistings?
    update?
  end
end
