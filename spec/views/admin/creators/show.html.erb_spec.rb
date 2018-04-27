# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/creators/show", type: :view do
  before(:each) do
    @model_class = assign(:model_name, Creator)
    @creator     = assign(:creator, create(:minimal_creator))
  end

  it "renders" do
    render
  end
end
