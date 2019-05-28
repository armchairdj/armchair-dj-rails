# frozen_string_literal: true

require "rails_helper"

RSpec.describe "admin/creators/show" do
  login_root

  before do
    @model_class = assign(:model_name, Creator)
    @creator     = assign(:creator, creator)
  end

  context "with primary individual creator" do
    let(:creator) { create(:minimal_creator, :primary, :individual, :with_published_post) }

    it "renders" do
      render
    end
  end

  context "with secondary creator" do
    let(:creator) { create(:minimal_creator, :secondary, :with_published_post) }

    it "renders" do
      render
    end
  end

  context "with collective creator" do
    let(:creator) { create(:minimal_creator, :collective, :with_published_post) }

    it "renders" do
      render
    end
  end
end
