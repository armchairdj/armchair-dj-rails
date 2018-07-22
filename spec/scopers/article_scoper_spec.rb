# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArticleScoper do
  describe "concerns" do
    it_behaves_like "a_scoper", Article
  end
end
