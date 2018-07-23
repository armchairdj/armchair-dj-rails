# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/creators/edit" do
  login_root

  before(:each) do
    2.times do
      create(:minimal_creator, :primary,   :collective)
      create(:minimal_creator, :primary,   :individual)
      create(:minimal_creator, :secondary, :collective)
      create(:minimal_creator, :secondary, :individual)
    end

    @model_class = assign(:model_name, Creator)
    @creator     = assign(:creator, creator)

    @available_pseudonyms = assign(:available_pseudonyms, creator.available_pseudonyms)
    @available_real_names = assign(:available_real_names, Creator.available_real_names)
    @available_members    = assign(:available_members,    Creator.available_members)
    @available_groups     = assign(:available_groups,     Creator.available_groups)
  end

  context "primary individual creator" do
    let(:creator) { create(:minimal_creator, :primary, :individual) }

    it "renders edit creator form" do
      render

      assert_select "form[action=?][method=?]", admin_creator_path(@creator), "post" do
        # TODO
      end
    end
  end

  context "secondary creator" do
    let(:creator) { create(:minimal_creator, :secondary) }

    it "renders edit creator form" do
      render

      assert_select "form[action=?][method=?]", admin_creator_path(@creator), "post" do
        # TODO
      end
    end
  end

  context "collective creator" do
    let(:creator) { create(:minimal_creator, :collective) }

    it "renders edit creator form" do
      render

      assert_select "form[action=?][method=?]", admin_creator_path(@creator), "post" do
        # TODO
      end
    end
  end
end
