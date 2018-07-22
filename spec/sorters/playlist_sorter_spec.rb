# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistSorter do
  describe "concerns" do
    it_behaves_like "a_sorter", Playlist
  end
end
