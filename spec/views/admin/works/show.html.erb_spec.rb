# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/works/show", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Work)
    @work        = assign(:work, create(:minimal_song, :with_published_post))
  end

  it "renders" do
    render
  end
end
