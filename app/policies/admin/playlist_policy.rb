# frozen_string_literal: true

class Admin::PlaylistPolicy < AdminPolicy
  def reorder_facets?
    update?
  end
end
