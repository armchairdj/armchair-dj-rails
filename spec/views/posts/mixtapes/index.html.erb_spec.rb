# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/mixtapes/index" do
  before do
    create_list(:minimal_mixtape, 3, :published)

    @mixtapes = assign(:mixtapes, Mixtape.for_public.page(1))
  end

  it "renders a list of mixtapes" do
    render
  end
end
