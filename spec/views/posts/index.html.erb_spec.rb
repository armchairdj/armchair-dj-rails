# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/index", type: :view do
  before(:each) do
    10.times do
      create(:complete_standalone_post, :published)
    end

    11.times do
      create(:complete_review, :published)
    end

    @posts = assign(:posts, Post.for_site.page(1))
  end

  it "renders a list of works" do
    render
  end
end
