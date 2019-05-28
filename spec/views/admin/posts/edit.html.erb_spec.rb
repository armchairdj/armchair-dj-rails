# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/edit" do
  login_root

  context "with article" do
    before do
      @view_path   = assign(:view_path, "articles")
      @model_class = assign(:model_name, Article)

      3.times { create(:minimal_tag) }

      @tags = assign(:tags, Tag.all.alpha)

      @post = @article = create(:minimal_article)

      assign(:review, @article)
      assign(:post,   @article)
    end

    context "with pristine instance" do
      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_article_path(@article), "post" do
          assert_select("div.error-notification", count: 0)

          assert_select("textarea[name=?]", "article[body]")
          assert_select("textarea[name=?]", "article[summary]")
          assert_select("textarea[name=?]", "article[slug]")
          assert_select("input[name=?]",    "article[publish_on]")
        end
      end
    end

    context "with errors" do
      before do
        @article.summary = "too short"
        @article.valid?
      end

      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_article_path(@article), "post" do
          assert_select("div.error-notification")

          assert_select("textarea[name=?]", "article[body]")
          assert_select("textarea[name=?]", "article[summary]")
          assert_select("textarea[name=?]", "article[slug]")
          assert_select("input[name=?]",    "article[publish_on]")
        end
      end
    end
  end

  context "with mixtape" do
    before do
      @view_path   = assign(:view_path, "mixtapes")
      @model_class = assign(:model_name, Mixtape)

      3.times do
        create(:minimal_playlist)
        create(:minimal_tag)
      end

      @tags      = assign(:tags,      Tag.all.alpha)
      @playlists = assign(:playlists, Playlist.all.alpha)

      @post = @mixtape = create(:minimal_mixtape)

      assign(:review, @mixtape)
      assign(:post,   @mixtape)
    end

    context "with pristine instance" do
      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_mixtape_path(@mixtape), "post" do
          assert_select("div.error-notification", count: 0)

          assert_select("textarea[name=?]", "mixtape[body]")
          assert_select("textarea[name=?]", "mixtape[summary]")
          assert_select("textarea[name=?]", "mixtape[slug]")
          assert_select("input[name=?]",    "mixtape[publish_on]")
        end
      end
    end

    context "with errors" do
      before do
        @mixtape.summary = "too short"
        @mixtape.valid?
      end

      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_mixtape_path(@mixtape), "post" do
          assert_select("div.error-notification", count: 1)

          assert_select("textarea[name=?]", "mixtape[body]")
          assert_select("textarea[name=?]", "mixtape[summary]")
          assert_select("textarea[name=?]", "mixtape[slug]")
          assert_select("input[name=?]",    "mixtape[publish_on]")
        end
      end
    end
  end

  context "with review" do
    before do
      @view_path   = assign(:view_path, "reviews")
      @model_class = assign(:model_name, Review)

      3.times do
        create(:minimal_creator)
        create(:minimal_song)
        create(:minimal_tag)
      end

      @tags  = assign(:tags,  Tag.all.alpha)
      @works = assign(:works, Work.grouped_by_medium)

      @post = @review = create(:minimal_review)

      assign(:review, @review)
      assign(:post,   @review)
    end

    context "with pristine instance" do
      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_review_path(@review), "post" do
          assert_select("div.error-notification", count: 0)

          assert_select("textarea[name=?]", "review[body]")
          assert_select("textarea[name=?]", "review[summary]")
          assert_select("textarea[name=?]", "review[slug]")
          assert_select("input[name=?]",    "review[publish_on]")
        end
      end
    end

    context "with errors" do
      before do
        @review.summary = "too short"
        @review.valid?
      end

      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_review_path(@review), "post" do
          assert_select("div.error-notification", count: 1)

          assert_select("textarea[name=?]", "review[body]")
          assert_select("textarea[name=?]", "review[summary]")
          assert_select("textarea[name=?]", "review[slug]")
          assert_select("input[name=?]",    "review[publish_on]")
        end
      end
    end
  end
end
