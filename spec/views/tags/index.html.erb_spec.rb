require "rails_helper"

RSpec.describe "tags/index", type: :view do
  before(:each) do
    11.times do
      create(:minimal_tag, :with_published_post)
    end

    10.times do
      create(:minimal_tag, :with_viewable_work)
    end

    @model_class = assign(:model_name, Tag)
    @tags        = assign(:tags, Tag.for_site.page(1))
  end

  it "renders a list of admin/tags" do
    render
  end
end
