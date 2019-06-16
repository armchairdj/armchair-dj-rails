# frozen_string_literal: true

require "rails_helper"

RSpec.describe Posts::PostsController do
  it_behaves_like "a_paginatable_controller"

  describe "GET #index" do
    it_behaves_like "a_public_index"
  end

  describe "GET #feed" do
    before do
      allow(described_class).to receive(:feed_post_count).and_return(5)
      create_list(:minimal_article, 2, :published)
      create_list(:minimal_review, 2, :published)
      create_list(:minimal_mixtape, 2, :published)
    end

    it "renders recent published posts as rss" do
      get :feed, params: { format: :rss }

      expect(response).to have_http_status(200)

      expect(assigns(:posts)).to have(5).items
    end

    xit "will not render in other formats" do
      get "/feed"

      is_expected.to render_bad_request
    end
  end

  describe ".feed_post_count" do
    subject { described_class.feed_post_count }

    it { is_expected.to eq(100) }
  end
end
