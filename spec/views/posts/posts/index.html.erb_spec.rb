require "rails_helper"

RSpec.describe "posts/posts/index" do
  before(:each) do
    create(:minimal_article, :published)
    create(:minimal_review,  :published)
    create(:minimal_mixtape, :published)

    @posts = assign(:posts, Post.for_public.page(1))
  end

  it "renders a list of posts" do
    render
  end
end
