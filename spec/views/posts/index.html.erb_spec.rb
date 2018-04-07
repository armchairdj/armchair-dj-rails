require 'rails_helper'

RSpec.describe 'posts/index', type: :view do
  before(:each) do
    10.times do
      create(:standalone_post)
    end

    11.times do
      create(:review_post)
    end

    @posts = assign(:posts, Post.all.reverse_cron.page(1))
  end

  it "renders a list of posts" do
    render
  end
end
