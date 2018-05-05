# frozen_string_literal: true

require "rails_helper"

RSpec.describe "creators/index", type: :view do
  before(:each) do
    21.times do
      create(:minimal_creator, :with_published_post)
    end

    @creators = assign(:creators, Creator.all.alpha.page(1))
  end

  it "renders a list of works" do
    render
  end
end
