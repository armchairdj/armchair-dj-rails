require "rails_helper"

RSpec.describe "admin/tags/edit", type: :view do
  login_root

  before(:each) do
    5.times do
      create(:minimal_category)
    end

    @model_class = assign(:model_name, Tag)
    @categories  = assign(:categories, Category.for_admin.alpha)
  end

  context "with work" do
    before(:each) do
      @tag = assign(:tag, create(:minimal_tag, :with_viewable_work))
    end

    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_tag_path(@tag), "post" do
        # TODO
      end
    end
  end

  context "with post" do
    before(:each) do
      @tag = assign(:tag, create(:minimal_tag, :with_published_post))
    end

    it "renders form" do
      render

      assert_select "form[action=?][method=?]", admin_tag_path(@tag), "post" do
        # TODO
      end
    end
  end
end
