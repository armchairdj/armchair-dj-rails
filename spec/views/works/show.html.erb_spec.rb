# frozen_string_literal: true

require "rails_helper"

RSpec.describe "works/show", type: :view do
  before(:each) do
    @work = assign(:work, create(:minimal_song, :with_published_post))
  end

  it "renders" do
    render
  end
end
