# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/works/new", type: :view do
  login_root

  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:minimal_role)
    end
  end

  context "initial state" do
    before(:each) do
      @model_class = assign(:model_name, Work)
      @work        = assign(:work, build(:work))
      @types       = assign(:types, Work.type_options)
    end

    it "renders form with only the type dropdown" do
      render

      assert_select "form[action=?][method=?]", admin_works_path, "post" do
        # TODO assert only one field
      end
    end
  end

  context "with populated type" do
    before(:each) do
      @model_class = assign(:model_name, Work)
      @work        = assign(:work, build(:song))
      @types       = assign(:types, Work.type_options)

      @work.prepare_credits
      @work.prepare_contributions
      @work.prepare_milestones

      @creators    = assign(:creators, Creator.all.alpha)
      @roles       = assign(:roles,    Role.where(work_type: @work.true_model_name.name))
      @works       = assign(:works,     @work.grouped_parent_dropdown_options)
    end

    it "renders fully populated form" do
      render

      assert_select "form[action=?][method=?]", admin_works_path, "post" do
        # TODO assert all fields
      end
    end
  end
end
