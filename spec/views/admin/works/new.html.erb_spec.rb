# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/works/new", type: :view do
  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:minimal_medium, :with_tags)
      create(:minimal_role)
    end

    @model_class = assign(:model_name, Work)
    @work        = assign(:work, build(:work))

    @creators   = assign(:creators,   Creator.all.alpha    )
    @media      = assign(:media,      Medium.select_options)
    @roles      = assign(:roles,      Role.grouped_options )
    @categories = assign(:categories, []                   )
  end

  it "renders new work form" do
    render

    assert_select "form[action=?][method=?]", admin_works_path, "post" do
      # TODO
    end
  end
end
