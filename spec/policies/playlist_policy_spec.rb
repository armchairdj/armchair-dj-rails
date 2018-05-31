# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistPolicy do
  it_behaves_like "a_public_policy" do
    let(:record) { create(:minimal_playlist) }
  end
end
