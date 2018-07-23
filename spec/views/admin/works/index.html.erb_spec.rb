# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/works/index" do
  login_root

  before(:each) do
    3.times { create(:minimal_song) }

    @model_class = assign(:model_name, Work)
    @collection    = assign(:collection, Ginsu::Collection.new(Work.all))
    @works       = assign(:works, @collection.resolve)
  end

  it "renders a list of works" do
    render
  end
end
