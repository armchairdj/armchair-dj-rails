# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagSorter do
  describe "concerns" do
    it_behaves_like "a_sorter", Tag
  end
end
