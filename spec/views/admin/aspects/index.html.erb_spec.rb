require "rails_helper"

RSpec.describe "admin/aspects/index", type: :view do
  login_root

  before(:each) do
    3.times { create(:minimal_aspect) }

    @model_class = assign(:model_name, Aspect)
    @relation    = assign(:relation, DicedRelation.new(Aspect.all))
    @aspects     = assign(:aspects, @relation.resolve)
  end

  it "renders a list of aspects" do
    render
  end
end
