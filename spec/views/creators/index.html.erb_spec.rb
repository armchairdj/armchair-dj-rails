require 'rails_helper'

RSpec.describe 'creators/index', type: :view do
  before(:each) do
    assign(:creators, [
      create(:minimal_creator),
      create(:minimal_creator)
    ])
  end

  it "renders a list of creators" do
    render
  end
end
