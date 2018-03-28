require 'rails_helper'

RSpec.describe 'creators/show', type: :view do
  before(:each) do
    @creator = assign(:creator, create(:minimal_creator))
  end

  it "renders attributes in <p>" do
    render
  end
end
