# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/works/edit", type: :view do
  login_root

  before(:each) do
    3.times do
      create(:minimal_creator)
      create(:complete_medium)
      create(:minimal_role)
    end

    @model_class = assign(:model_name, Work)
    @work        = assign(:work, create(:minimal_song))

    @creators    = assign(:creators,   Creator.all.alpha                    )
    @media       = assign(:media,      Medium.all.alpha                     )
    @roles       = assign(:roles,      Role.all.alpha                       )
    @categories  = assign(:categories, @work.medium.category_aspect_options        )
    @works       = assign(:works,      @work.grouped_parent_dropdown_options)
  end

  it "renders the edit work form" do
    render

    assert_select "form[action=?][method=?]", admin_work_path(@work), "post" do
      # TODO
    end
  end
end
