# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/roles/show" do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Role)
    @role        = assign(:role, create(:minimal_role))
  end

  it "renders" do
    render
  end
end
