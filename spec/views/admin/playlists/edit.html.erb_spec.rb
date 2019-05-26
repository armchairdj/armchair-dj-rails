# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/playlists/edit" do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Playlist)
    @playlist    = assign(:playlist, create(:minimal_playlist, :with_published_post))
    @works       = assign(:works, Work.grouped_by_medium)
  end

  it "renders the edit playlist form" do
    render

    assert_select "form[action=?][method=?]", admin_playlist_path(@playlist), "post" do
    end
  end
end
