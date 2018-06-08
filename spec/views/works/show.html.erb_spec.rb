# frozen_string_literal: true

require "rails_helper"

RSpec.describe "works/show", type: :view do
  before(:each) do
    @work = assign(:work, create(:minimal_work, :with_published_publication))
  end

  it "renders" do
    render
  end
end
