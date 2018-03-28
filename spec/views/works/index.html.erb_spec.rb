require 'rails_helper'

RSpec.describe 'works/index', type: :view do
  before(:each) do
    assign(:works, [
      create(:minimal_work),
      create(:minimal_work)
    ])
  end

  it "renders a list of works" do
    render
  end
end
