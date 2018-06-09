# frozen_string_literal: true

require "rails_helper"

RSpec.describe "creators/show", type: :view do
  before(:each) do
    @creator = assign(:creator, create(:minimal_creator, :with_published_post))
  end

  it "renders" do
    render
  end
end
