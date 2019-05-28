# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/aspects/edit" do
  login_root

  before do
    @model_class = assign(:model_name, Aspect)
    @aspect      = assign(:aspect, create(:minimal_aspect, :with_published_post))
  end

  it "renders form" do
    render

    assert_select "form[action=?][method=?]", admin_aspect_path(@aspect), "post" do
      # TODO
    end
  end
end
