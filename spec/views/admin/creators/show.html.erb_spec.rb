require 'rails_helper'

RSpec.describe 'creators/show', type: :view do
  before(:each) do
    @creator = assign(:creator, Creator.create!(
      :index => "Index",
      :show => "Show"
    ))
  end

  it "renders" do
    render
    expect(rendered).to match(/Index/)
    expect(rendered).to match(/Show/)
  end
end
