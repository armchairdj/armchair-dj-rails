# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/creators/index", type: :view do
  login_root

  let(:dummy) { Admin::CreatorsController.new }

  before(:each) do
    3.times { create(:minimal_creator) }

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Creator)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @creators    = assign(:creators, Creator.all.alpha.page(1))
  end

  it "renders a list of creators" do
    render
  end
end
