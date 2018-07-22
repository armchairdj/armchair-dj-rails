# frozen_string_literal: true

require "rails_helper"

RSpec.describe ArticleSorter do
  describe "concerns" do
    it_behaves_like "a_sorter", Article
  end
end
