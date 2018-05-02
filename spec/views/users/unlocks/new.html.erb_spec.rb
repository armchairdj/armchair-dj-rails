# frozen_string_literal: true

require "rails_helper"

RSpec.describe "users/unlocks/new", type: :view do
  before(:each) do
    @model_class = assign(:model_name, User)
    @user        = assign(:user, create(:member))
  end

  it "renders" do
    render
  end
end
