require "rails_helper"

RSpec.describe "admin/playlists/new", type: :view do
  before(:each) do
    assign(:admin_playlist, Playlist.new())
  end

  it "renders new admin_playlist form" do
    render

    assert_select "form[action=?][method=?]", admin_playlists_path, "post" do
    end
  end
end
