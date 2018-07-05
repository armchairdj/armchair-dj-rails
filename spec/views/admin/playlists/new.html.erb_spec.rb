require "rails_helper"

RSpec.describe "admin/playlists/new", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Playlist)
    @playlist    = assign(:playlist, build(:playlist))
    @works       = assign(:works, Work.grouped_by_medium)
  end

  it "renders new playlist form" do
    render

    assert_select "form[action=?][method=?]", admin_playlists_path, "post" do
    end
  end
end
