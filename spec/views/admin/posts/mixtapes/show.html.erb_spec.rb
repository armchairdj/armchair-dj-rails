# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/mixtapes/show" do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Mixtape)
    @mixtape     = assign(:mixtape, create(:complete_mixtape))
  end

  it "renders" do
    render
  end
end
