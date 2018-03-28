require 'rails_helper'

RSpec.describe 'creators/new', type: :view do
  before(:each) do
    assign(:creator, build(:creator))
  end

  it "renders new creator form" do
    render

    assert_select "form[action=?][method=?]", creators_path, "post" do
    end
  end
end
