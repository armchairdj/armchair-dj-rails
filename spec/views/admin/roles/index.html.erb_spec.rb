# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/roles/index" do
  login_root

  before do
    create_list(:minimal_role, 3)

    @model_class = assign(:model_name, Role)
    @collection = assign(:collection, Ginsu::Collection.new(Role.all))
    @roles = assign(:roles, @collection.resolved)
  end

  it "renders a list of roles" do
    render
  end
end
