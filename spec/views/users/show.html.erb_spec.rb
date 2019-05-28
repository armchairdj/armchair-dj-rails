# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/show" do
  before do
    @model_class = assign(:model_name, User)
    @user        = assign(:user, create(:root, :with_published_post, :with_links))
    @links       = assign(:links, @user.links)
  end

  it "renders" do
    render
  end
end
