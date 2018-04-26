require "rails_helper"

RSpec.describe PostsController, type: :controller do
  context "concerns" do
    it_behaves_like "a public controller"

    it_behaves_like "an seo paginatable controller" do
      let(:expected_redirect) { posts_path }
    end
  end

  describe "GET #index" do
    context "without records" do
      it "renders" do
        get :index

        should successfully_render("posts/index")

        expect(assigns(:posts)).to paginate(0).of_total_records(0)
      end
    end

    context "with unpublished records" do
      before(:each) do
        10.times { create(:song_review    ) }
        11.times { create(:standalone_post) }
      end

      it "renders" do
        get :index

        should successfully_render("posts/index")

        expect(assigns(:posts)).to paginate(0).of_total_records(0)
      end
    end

    context "with published records" do
      before(:each) do
        10.times { create(:song_review,     :published) }
        11.times { create(:standalone_post, :published) }
      end

      it "renders" do
        get :index

        should successfully_render("posts/index")

        expect(assigns(:posts)).to paginate(20).of_total_records(21)
      end

      it "renders second page" do
        get :index, params: { page: "2" }

        should successfully_render("posts/index")

        expect(assigns(:posts)).to paginate(1).of_total_records(21)
      end
    end
  end

  describe "GET #show" do
    let(:post) { create(:minimal_post, slug: "slug/path") }

    it "renders" do
      get :show, params: { slug: post.slug }

      should successfully_render("posts/show")

      expect(assigns(:post)).to eq(post)
    end
  end

  describe "GET #feed" do
    before(:each) do
      101.times { create(:minimal_post, :published) }
    end

    it "renders last 100 published posts as rss" do
      get :feed, params: { format: :rss }

      expect(response).to have_http_status(200)

      expect(assigns(:posts).length).to eq(100)
    end
  end
end
