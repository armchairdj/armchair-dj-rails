require "rails_helper"

RSpec.describe "media/index", type: :view do
  before(:each) do
    21.times do
      create(:minimal_medium, :with_published_post)
    end

    @model_class = assign(:model_name, Medium)
    @media       = assign(:media, Medium.for_admin.page(1))
  end

  it "renders a list of media" do
    render
  end
end
