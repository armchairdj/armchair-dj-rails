require 'rails_helper'

RSpec.describe 'creators/edit', type: :view do
  before(:each) do
    @creator = assign(:creator, create(:minimal_creator))
  end

  it "renders the edit creator form" do
    render

    assert_select "form[action=?][method=?]", creator_path(@creator), "post" do
      # TODO
    end
  end
end
