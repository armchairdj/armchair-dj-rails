# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Homepage" do
  it "shows masthead" do
    visit posts_url

    expect(page).to have_content "Armchair"
    expect(page).to have_content "DJ"
    expect(page).to have_content "A catalog of popular culture,"
    expect(page).to have_content "plus the occasional mixtape."
  end
end
