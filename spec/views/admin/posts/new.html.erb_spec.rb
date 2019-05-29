# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/new" do
  login_root

  context "with article" do
    before do
      @view_path   = assign(:view_path, "articles")
      @model_class = assign(:model_name, Article)

      create_list(:minimal_tag, 3)

      @post = @article = build(:article)

      assign(:review, @article)
      assign(:post,   @article)
    end

    context "with pristine instance" do
      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_articles_path, "post" do
          assert_select("div.error-notification",               count: 0)
          assert_select("textarea[name=?]", "mixtape[body]",    count: 0)
          assert_select("textarea[name=?]", "mixtape[summary]", count: 0)
        end
      end
    end

    context "with errors" do
      describe "blank form submitted" do
        before do
          @article.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_articles_path, "post" do
            assert_select("div.error-notification", count: 1)
          end
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

      @playlists = assign(:playlists, Playlist.all.alpha)

      @post = @mixtape = build(:mixtape)

      assign(:review, @mixtape)
      assign(:post,   @mixtape)
    end

    context "with pristine instance" do
      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_mixtapes_path, "post" do
          assert_select("div.error-notification",               count: 0)
          assert_select("textarea[name=?]", "mixtape[body]",    count: 0)
          assert_select("textarea[name=?]", "mixtape[summary]", count: 0)
        end
      end
    end

    context "with errors" do
      before do
        @mixtape.valid?
      end

      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_mixtapes_path, "post" do
          assert_select("div.error-notification", count: 1)
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

      @works = assign(:works, Work.grouped_by_medium)

      @post = @review = build(:review)

      assign(:review, @review)
      assign(:post,   @review)
    end

    context "with pristine instance" do
      it "renders form" do
        render

        assert_select "form[action=?][method=?]", admin_reviews_path, "post" do
          assert_select("div.error-notification",               count: 0)
          assert_select("textarea[name=?]", "mixtape[body]",    count: 0)
          assert_select("textarea[name=?]", "mixtape[summary]", count: 0)
        end
      end
    end

    context "with errors" do
      describe "blank form submitted" do
        before do
          @review.valid?
        end

        it "renders form" do
          render

          assert_select "form[action=?][method=?]", admin_reviews_path, "post" do
            assert_select("div.error-notification", count: 1)
          end
        end
      end
    end
  end
end
