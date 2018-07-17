# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/mixtapes/edit", type: :view do
  login_root

  before(:each) do
    3.times do
      create(:minimal_playlist)
      create(:minimal_tag)
    end

    @model_class = assign(:model_name, Mixtape)

    @tags      = assign(:tags,      Tag.all.alpha)
    @playlists = assign(:playlists, Playlist.all.alpha)

    @post = @mixtape = create(:minimal_mixtape)

    assign(:review, @mixtape)
    assign(:post,   @mixtape)
  end

  context "pristine" do
    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_mixtape_path(@mixtape), "post" do
        assert_select("div.error-notification", { count: 0 })

        assert_select("textarea[name=?]", "mixtape[body]")
        assert_select("textarea[name=?]", "mixtape[summary]")
        assert_select("input[name=?]",    "mixtape[slug]")
        assert_select("input[name=?]",    "mixtape[publish_on]")
      end
    end
  end

  context "with errors" do
    before(:each) do
      @mixtape.summary = "too short"
      @mixtape.valid?
    end

    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_mixtape_path(@mixtape), "post" do
        assert_select("div.error-notification", { count: 1 })

        assert_select("textarea[name=?]", "mixtape[body]")
        assert_select("textarea[name=?]", "mixtape[summary]")
        assert_select("input[name=?]",    "mixtape[slug]")
        assert_select("input[name=?]",    "mixtape[publish_on]")
      end
    end
  end
end
