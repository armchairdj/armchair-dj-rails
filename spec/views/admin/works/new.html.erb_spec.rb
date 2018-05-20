# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/works/new", type: :view do
  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:complete_medium)
      create(:minimal_role)
    end
  end

  context "initial state" do
    before(:each) do
      @media       = assign(:media, Medium.all.alpha)
      @model_class = assign(:model_name, Work)
      @work        = assign(:work, build(:work))
    end

    it "renders form with only the media dropdown" do
      render

      assert_select "form[action=?][method=?]", admin_works_path, "post" do
        # TODO assert only one field
      end
    end
  end

  context "with populated medium" do
    before(:each) do
      @media       = assign(:media, Medium.all.alpha)

      @model_class = assign(:model_name, Work)
      @work        = assign(:work, build(:work, medium_id: @media.first.id))

      @creators    = assign(:creators,   Creator.all.alpha             )
      @roles       = assign(:roles,      Role.options_for(@work.medium))
      @categories  = assign(:categories, @media.first.tags_by_category )
    end

    xit "renders fully populated form" do
      render

      assert_select "form[action=?][method=?]", admin_works_path, "post" do
        # TODO assert all fields
      end
    end
  end
end
