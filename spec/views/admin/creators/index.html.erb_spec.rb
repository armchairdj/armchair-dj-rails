# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/creators/index", type: :view do
  before(:each) do
    21.times do
      create(:minimal_creator, :with_published_post)
    end

    @model_class = assign(:model_name, Creator)
    @scope       = assign(:scope, :for_admin)
    @sort        = assign(:sort, @model_class.default_admin_sort)
    @creators    = assign(:creators, Creator.all.alpha.page(1))
  end

  it "renders a list of creators" do
    render
  end
end
