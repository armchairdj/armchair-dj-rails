# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/show", type: :view do
  before(:each) do
    @model_class = assign(:model_name, User)
    @user        = assign(:user, create(:writer, :with_published_post))
  end

  it "renders" do
    render
  end
end
