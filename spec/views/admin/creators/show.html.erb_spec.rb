require 'rails_helper'

RSpec.describe 'admin/creators/show', type: :view do
  before(:each) do
    @creator = assign(:creator, create(:minimal_creator))
  end

  it "renders" do
    render
  end
end