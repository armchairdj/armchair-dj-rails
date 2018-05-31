# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/creators/edit", type: :view do
  login_root

  before(:each) do
    2.times do
      create(:minimal_creator, :primary,   :collective)
      create(:minimal_creator, :primary,   :individual)
      create(:minimal_creator, :secondary, :collective)
      create(:minimal_creator, :secondary, :individual)
    end

    @model_class = assign(:model_name, Creator)
    @creator     = assign(:creator, create(:minimal_creator))
  end

  it "renders edit creator form" do
    render

    assert_select "form[action=?][method=?]", admin_creator_path(@creator), "post" do
      # TODO
    end
  end
end
