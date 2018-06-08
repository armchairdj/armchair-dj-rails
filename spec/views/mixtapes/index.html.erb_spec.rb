# frozen_string_literal: true

require "rails_helper"

RSpec.describe "mixtapes/index", type: :view do
  before(:each) do
    21.times do
      create(:complete_mixtape, :published)
    end

    @mixtapes = assign(:mixtapes, Mixtape.for_site.page(1))
  end

  it "renders a list of mixtapes" do
    render
  end
end
