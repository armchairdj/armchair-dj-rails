# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/mixtapes/index" do
  login_root

  before(:each) do
    3.times { create(:minimal_mixtape) }

    @model_class = assign(:model_name, Mixtape)
    @collection    = assign(:collection, Ginsu::Collection.new(Mixtape.all))
    @mixtapes    = assign(:mixtapes, @collection.resolve)
  end

  it "renders a list of mixtapes" do
    render
  end
end
