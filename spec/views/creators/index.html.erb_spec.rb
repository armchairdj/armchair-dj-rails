require 'rails_helper'

RSpec.describe 'creators/index', type: :view do
  before(:each) do
    assign(:creators, [
      Creator.create!(
        :index => "Index",
        :show => "Show"
      ),
      Creator.create!(
        :index => "Index",
        :show => "Show"
      )
    ])
  end

  it "renders a list of creators" do
    render
    assert_select "tr>td", :text => "Index".to_s, :count => 2
    assert_select "tr>td", :text => "Show".to_s, :count => 2
  end
end
