# frozen_string_literal: true

require "rails_helper"

RSpec.describe "articles/show", type: :view do
  context "standalone" do
    before(:each) do
      @article = assign(:article, create(:complete_article))
    end

    it "renders" do
      render
    end
  end

  context "review" do
    before(:each) do
      @article = assign(:article, create(:complete_review))
    end
    it "renders" do
      render
    end
  end
end
