require "rails_helper"

RSpec.describe "admin/media/index", type: :view do
  before(:each) do
    21.times do
      create(:minimal_medium, :with_published_post)
    end

    @model_class = assign(:model_name, Medium)
    @scope       = assign(:scope, :for_admin)
    @sort        = assign(:sort, @model_class.default_sort)
    @media       = assign(:media, Medium.for_admin.page(1))
  end

  it "renders a list of admin/media" do
    render
  end
end
