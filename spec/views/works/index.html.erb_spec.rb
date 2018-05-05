# frozen_string_literal: true

require "rails_helper"

RSpec.describe "works/index", type: :view do
  before(:each) do
    21.times do
      create(:minimal_work, :with_published_post)
    end

    @works = assign(:works, Work.all.alpha.page(1))
  end

  it "renders a list of works" do
    render
  end
end
