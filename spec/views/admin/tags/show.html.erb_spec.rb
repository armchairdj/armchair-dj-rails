require "rails_helper"

RSpec.describe "admin/tags/show", type: :view do
  login_root

  before(:each) do
    @model_class = assign(:model_name, Tag)
  end

  context "with work" do
    before(:each) do
      @tag = assign(:tag, create(:minimal_tag, :with_viewable_work))
    end

    it "renders" do
      render
    end
  end

  context "with article" do
    before(:each) do
      @tag = assign(:tag, create(:minimal_tag, :with_published_post))
    end

    it "renders" do
      render
    end
  end
end
