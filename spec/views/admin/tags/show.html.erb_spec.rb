# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/tags/show" do
  login_root

  before do
    @model_class = assign(:model_name, Tag)
    @tag         = assign(:tag, create(:minimal_tag, :with_published_post))
  end

  it "renders" do
    render
  end
end
