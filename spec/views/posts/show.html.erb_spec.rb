# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/show", type: :view do
  context "standalone" do
    before(:each) do
      @post = assign(:post, create(:complete_standalone_post))
    end

    it "renders" do
      render
    end
  end

  context "review" do
    before(:each) do
      @post = assign(:post, create(:complete_review))
    end
    it "renders" do
      render
    end
  end
end
