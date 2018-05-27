# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/index", type: :view do
  let(:dummy) { Admin::PostsController.new }

  before(:each) do
    10.times do
      create(:standalone_post, :published)
    end

    11.times do
      create(:review, :published)
    end

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Post)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @posts       = assign(:posts, Post.for_admin.page(1))
  end

  it "renders a list of posts" do
    render
  end
end
