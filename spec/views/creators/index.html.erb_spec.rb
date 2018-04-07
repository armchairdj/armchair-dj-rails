require 'rails_helper'

RSpec.describe 'creators/index', type: :view do
  before(:each) do
    21.times do
      create(:minimal_creator)
    end

    @creators = assign(:creators, Creator.all.alphabetical.page(1))
  end

  it "renders a list of works" do
    render
  end
end
