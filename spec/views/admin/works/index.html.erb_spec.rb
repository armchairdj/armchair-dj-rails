# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/works/index", type: :view do
  login_root

  before(:each) do
    3.times { create(:minimal_song) }

    @model_class = assign(:model_name, Work)
    @relation    = assign(:relation, DicedRelation.new(Work.all))
    @works       = assign(:works, @relation.resolve)
  end

  it "renders a list of works" do
    render
  end
end
