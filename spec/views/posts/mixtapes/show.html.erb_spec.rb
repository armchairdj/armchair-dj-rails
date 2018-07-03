# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/mixtapes/show", type: :view do
  before(:each) do
    @mixtape = assign(:mixtape, create(:complete_mixtape))
  end

  it "renders" do
    render
  end
end
