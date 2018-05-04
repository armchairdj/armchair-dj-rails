# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/index", type: :view do
  before(:each) do
    21.times do
      create(:minimal_post, :published)
    end

    @posts = assign(:posts, Post.for_admin.page(1))
  end

  it "renders a list of works" do
    render
  end
end
