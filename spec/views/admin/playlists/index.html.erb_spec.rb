require "rails_helper"

RSpec.describe "admin/playlists/index", type: :view do
  login_root

  let(:dummy) { Admin::PlaylistsController.new }

  before(:each) do
    3.times { create(:minimal_playlist, :with_published_post) }

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Playlist)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @playlists   = assign(:playlists, Playlist.for_admin.page(1))
  end

  it "renders a list of admin/playlists" do
    render
  end
end
