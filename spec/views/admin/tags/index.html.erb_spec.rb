# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/tags/index" do
  login_root

  before do
    3.times { create(:minimal_tag) }

    @model_class = assign(:model_name, Tag)
    @collection = assign(:collection, Ginsu::Collection.new(Tag.all))
    @tags = assign(:tags, @collection.resolved)
  end

  it "renders a list of tags" do
    render
  end
end
