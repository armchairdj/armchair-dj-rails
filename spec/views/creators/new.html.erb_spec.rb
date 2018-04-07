require 'rails_helper'

RSpec.describe 'creators/new', type: :view do
  before(:each) do
    assign(:creator, Creator.new(
      :index => "MyString",
      :show => "MyString"
    ))
  end

  it "renders new creator form" do
    render

    assert_select "form[action=?][method=?]", creators_path, "post" do

      assert_select "input[name=?]", "creator[index]"

      assert_select "input[name=?]", "creator[show]"
    end
  end
end
