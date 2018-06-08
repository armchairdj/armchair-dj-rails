require "rails_helper"

RSpec.describe "admin/playlists/edit", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Playlist)
    @playlist    = assign(:playlist, create(:minimal_playlist, :with_published_publication))
    @works       = assign(:works, Work.grouped_options)
  end

  it "renders the edit playlist form" do
    render

    assert_select "form[action=?][method=?]", admin_playlist_path(@playlist), "post" do
    end
  end
end
