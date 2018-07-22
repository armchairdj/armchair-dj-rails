# frozen_string_literal: true

require "rails_helper"

RSpec.describe MixtapeSorter do
  describe "concerns" do
    it_behaves_like "a_sorter", Mixtape
  end
end
