# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/mixtapes/new", type: :view do
  login_root

  before(:each) do
    3.times do
      create(:minimal_playlist)
      create(:minimal_tag)
    end

    @model_class = assign(:model_name, Mixtape)

    @playlists = assign(:playlists,  Playlist.all.alpha)

    @post = @mixtape = build(:mixtape)

    assign(:review, @mixtape)
    assign(:post,   @mixtape)
  end

  context "pristine" do
    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_mixtapes_path, "post" do
        assert_select("div.error-notification",               { count: 0 })
        assert_select("textarea[name=?]", "mixtape[body]",    { count: 0 })
        assert_select("textarea[name=?]", "mixtape[summary]", { count: 0 })
      end
    end
  end

  context "with errors" do
    before(:each) do
      @mixtape.valid?
    end

    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_mixtapes_path, "post" do
        assert_select("div.error-notification", { count: 1 })
      end
    end
  end
end
