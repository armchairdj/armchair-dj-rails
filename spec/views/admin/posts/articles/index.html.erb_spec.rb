# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/articles/index", type: :view do
  login_root

  let(:dummy) { Admin::Posts::ArticlesController.new }

  before(:each) do
    21.times do
      create(:minimal_article, :published)
    end

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Article)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @articles    = assign(:articles, Article.for_admin.page(1))
  end

  it "renders a list of articles" do
    render
  end
end
