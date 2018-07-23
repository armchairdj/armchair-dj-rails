# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/mixtapes/index", type: :view do
  login_root

  before(:each) do
    3.times { create(:minimal_mixtape) }

    @model_class = assign(:model_name, Mixtape)
    @relation    = assign(:relation, DicedRelation.new(Mixtape.all))
    @mixtapes    = assign(:mixtapes, @relation.resolve)
  end

  it "renders a list of mixtapes" do
    render
  end
end
