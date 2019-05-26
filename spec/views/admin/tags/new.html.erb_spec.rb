# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/tags/new" do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Tag)
    @tag         = assign(:tag, build(:tag))
  end

  it "renders form" do
    render

    assert_select "form[action=?][method=?]", admin_tags_path, "post" do
      # TODO
    end
  end
end
