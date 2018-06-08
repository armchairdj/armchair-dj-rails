# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/creators/show", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Creator)
    @creator     = assign(:creator, create(:minimal_creator, :with_published_publication))
  end

  it "renders" do
    render
  end
end
