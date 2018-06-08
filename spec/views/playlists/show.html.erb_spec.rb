# frozen_string_literal: true

require "rails_helper"

RSpec.describe "playlists/show", type: :view do
  before(:each) do
    @playlist = assign(:playlist, create(:minimal_playlist, :with_published_publication))
  end

  it "renders" do
    render
  end
end
