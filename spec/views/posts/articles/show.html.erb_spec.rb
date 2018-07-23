# frozen_string_literal: true

require "rails_helper"

RSpec.describe "posts/articles/show" do
  before(:each) do
    @article = assign(:article, create(:complete_article))
  end

  it "renders" do
    render
  end
end
