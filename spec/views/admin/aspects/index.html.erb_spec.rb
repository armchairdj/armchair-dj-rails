# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/aspects/index" do
  login_root

  before(:each) do
    3.times { create(:minimal_aspect) }

    @model_class = assign(:model_name, Aspect)
    @collection = assign(:collection, Ginsu::Collection.new(Aspect.all))
    @aspects = assign(:aspects, @collection.resolved)
  end

  it "renders a list of aspects" do
    render
  end
end
