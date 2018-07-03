# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/mixtapes/index", type: :view do
  login_root

  let(:dummy) { Admin::Posts::MixtapesController.new }

  before(:each) do
    21.times do
      create(:minimal_mixtape, :published)
    end

    allow(dummy).to receive(:polymorphic_path).and_return("/")

    @model_class = assign(:model_name, Mixtape)
    @scope       = assign(:scope, "All")
    @sort        = assign(:sort, "Default")
    @dir         = assign(:dir, "ASC")
    @scopes      = dummy.send(:scopes_for_view, @scope)
    @sorts       = dummy.send(:sorts_for_view, @scope, @sort, @dir)
    @mixtapes    = assign(:mixtapes, Mixtape.for_admin.page(1))
  end

  it "renders a list of mixtapes" do
    render
  end
end
