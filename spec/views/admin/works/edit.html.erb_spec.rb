# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/works/edit" do
  login_root

  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:minimal_role)
    end

    @model_class = assign(:model_name, Work)
    @work        = assign(:work, create(:minimal_song))
    @media       = assign(:types, Work.media)

    @work.prepare_credits
    @work.prepare_contributions
    @work.prepare_milestones

    @creators = assign(:creators, Creator.all.alpha)
    @roles    = assign(:roles,    @work.available_roles)
  end

  it "renders the edit work form" do
    render

    assert_select "form[action=?][method=?]", admin_work_path(@work), "post" do
      # TODO
    end
  end
end
