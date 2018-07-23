require "rails_helper"

RSpec.describe "admin/tags/index", type: :view do
  login_root

  before(:each) do
    3.times { create(:minimal_tag) }

    @model_class = assign(:model_name, Tag)
    @relation    = assign(:relation, DicedRelation.new(Tag.all))
    @tags        = assign(:tags, @relation.resolve)
  end

  it "renders a list of tags" do
    render
  end
end
