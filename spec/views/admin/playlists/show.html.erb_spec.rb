require "rails_helper"

RSpec.describe "admin/playlists/show" do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Playlist)
    @playlist    = assign(:playlist, create(:minimal_playlist, :with_published_post))
  end

  it "renders" do
    render
  end
end
