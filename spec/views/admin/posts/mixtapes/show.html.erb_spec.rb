# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/mixtapes/show", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Mixtape)
    @mixtape     = assign(:mixtape, create(:complete_mixtape))
    @tags        = assign(:tags,  @mixtape.tags.alpha)
    @links       = assign(:links, @mixtape.links)
  end

  it "renders" do
    render
  end
end
