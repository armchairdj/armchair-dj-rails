# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/aspects/new" do
  login_root

  before do
    @model_class = assign(:model_name, Aspect)
    @aspect      = assign(:aspect, build(:aspect))
  end

  it "renders form" do
    render

    assert_select "form[action=?][method=?]", admin_aspects_path, "post" do
      # TODO
    end
  end
end
