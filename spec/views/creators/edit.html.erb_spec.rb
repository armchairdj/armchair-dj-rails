require 'rails_helper'

RSpec.describe 'creators/edit', type: :view do
  before(:each) do
    @creator = assign(:creator, Creator.create!(
      :index => "MyString",
      :show => "MyString"
    ))
  end

  it "renders the edit creator form" do
    render

    assert_select "form[action=?][method=?]", creator_path(@creator), "post" do

      assert_select "input[name=?]", "creator[index]"

      assert_select "input[name=?]", "creator[show]"
    end
  end
end
