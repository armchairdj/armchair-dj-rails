# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/works/index", type: :view do
  before(:each) do
    21.times do
      create(:stuffed_work, :with_published_post)
    end

    @model_class = assign(:model_name, Work)
    @scope       = assign(:scope, :for_admin)
    @sort        = assign(:sort, @model_class.default_admin_sort)
    @page        = assign(:page, 1)
    @works       = assign(:works, Work.all.alpha.page(1))
  end

  it "renders a list of works" do
    render
  end
end
