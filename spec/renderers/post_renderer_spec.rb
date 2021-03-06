# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostRenderer do
  describe "rendering" do
    describe "basics" do
      pending "renders markdown as html"
    end

    describe "internal links" do
      context "when successful" do
        pending "captures internal links and turns them into real links"
      end

      context "when failed" do
        pending "renders unlinked text"
        pending "logs failure"
      end
    end
  end
end
