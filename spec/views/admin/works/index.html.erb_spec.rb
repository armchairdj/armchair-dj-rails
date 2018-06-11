# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/works/index", type: :view do
  login_root

  let(:dummy) { Admin::WorksController.new }

  before(:each) do
    21.times do
      create(:stuffed_song, :with_published_post)
    end

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Work)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @works       = assign(:works, Work.all.alpha.page(1))
  end

  it "renders a list of works" do
    render
  end
end
