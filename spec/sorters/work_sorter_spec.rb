# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorkSorter do
  describe "concerns" do
    it_behaves_like "a_sorter", Work
  end
end
