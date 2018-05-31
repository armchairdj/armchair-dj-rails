# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/show", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Post)
    @post        = assign(:post, create(:minimal_post, :published))
  end

  it "renders" do
    render
  end
end
