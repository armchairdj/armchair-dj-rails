# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/posts/new", type: :view do
  context "initial state" do
    before(:each) do
      @model_class    = assign(:model_name, Post)
      @post           = assign(:post, build(:post))
      @selected_tab   = assign(:selected_tab, "post-choose-work")
      @available_tabs = assign(:selected_tab, ["post-choose-work", "post-new-work", "post-standalone"])
    end

    it "renders new post form" do
      render

      assert_select "form[action=?][method=?]", admin_posts_path, "post" do
        # TODO
      end
    end
  end

  context "after failed create" do
    pending "renders"
  end
end
