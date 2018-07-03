require "rails_helper"

RSpec.describe "posts/posts/index", type: :view do
  before(:each) do
    create(:complete_article, :published)
    create(:complete_review,  :published)
    create(:complete_mixtape, :published)

    @posts = assign(:posts, Post.for_site.page(1))
  end

  it "renders a list of posts" do
    render
  end
end
