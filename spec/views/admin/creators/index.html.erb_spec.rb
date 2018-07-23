# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/creators/index" do
  login_root

  before(:each) do
    3.times { create(:minimal_creator) }

    @model_class = assign(:model_name, Creator)
    @collection    = assign(:collection, Ginsu::Collection.new(Creator.all))
    @creators    = assign(:creators, @collection.resolve)
  end

  it "renders a list of creators" do
    render
  end
end
