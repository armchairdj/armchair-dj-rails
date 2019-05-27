# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/roles/edit" do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Role)
    @role        = assign(:role, create(:minimal_role))
  end

  it "renders form" do
    render

    assert_select "form[action=?][method=?]", admin_role_path(@role), "post" do
      # TODO
    end
  end
end
