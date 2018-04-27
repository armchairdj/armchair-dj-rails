# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/edit", type: :view do
  context "for standalone" do
    before(:each) do
      @model_class    = assign(:model_name, Post)
      @post           = assign(:post, create(:minimal_post))
      @selected_tab   = assign(:selected_tab, "post-standalone")
      @available_tabs = assign(:selected_tab, ["post-standalone"])
    end

    it "renders the edit form" do
      render

      assert_select "form[action=?][method=?]", admin_post_path(@post), "post" do
        # TODO
      end
    end
  end

  context "for review" do
    pending "renders the edit form"
  end
end
