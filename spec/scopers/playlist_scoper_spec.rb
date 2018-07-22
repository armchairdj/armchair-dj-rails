# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistScoper do
  describe "concerns" do
    it_behaves_like "a_scoper", Playlist
  end
end
