# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/index", type: :view do
  before(:each) do
    10.times do
      create(:standalone_post, :published)
    end

    11.times do
      create(:review, :published)
    end

    @model_class = assign(:model_name, Post)
    @scope       = assign(:scope, :for_admin)
    @sort        = assign(:sort, @model_class.default_sort)
    @posts       = assign(:posts, Post.for_admin.page(1))
  end

  it "renders a list of posts" do
    render
  end
end
