# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/mixtapes/show" do
  before do
    @mixtape = assign(:mixtape, create(:complete_mixtape))
  end

  it "renders" do
    render
  end
end
