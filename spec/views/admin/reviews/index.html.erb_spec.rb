# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/reviews/index", type: :view do
  login_root

  let(:dummy) { Admin::ReviewsController.new }

  before(:each) do
    21.times do
      create(:minimal_review, :published)
    end

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Review)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @reviews     = assign(:reviews, Review.for_admin.page(1))
  end

  it "renders a list of reviews" do
    render
  end
end
