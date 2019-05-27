# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/works/new" do
  login_root

  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:minimal_role)
    end
  end

  describe "initial state" do
    before(:each) do
      @model_class = assign(:model_name, Work)
      @work        = assign(:work, build(:work))
      @media       = assign(:types, Work.media)
    end

    it "renders form with only the type dropdown" do
      render

      assert_select "form[action=?][method=?]", admin_works_path, "post" do
        # TODO: assert only one field
      end
    end
  end

  context "with populated type" do
    before(:each) do
      @model_class = assign(:model_name, Work)
      @work        = assign(:work, build(:song))
      @media       = assign(:types, Work.media)

      @work.prepare_credits
      @work.prepare_contributions
      @work.prepare_milestones

      @creators = assign(:creators, Creator.all.alpha)
      @roles    = assign(:roles,    @work.available_roles)
    end

    it "renders fully populated form" do
      render

      assert_select "form[action=?][method=?]", admin_works_path, "post" do
        # TODO: assert all fields
      end
    end
  end
end
