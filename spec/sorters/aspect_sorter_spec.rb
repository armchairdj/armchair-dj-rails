# frozen_string_literal: true

require "rails_helper"

RSpec.describe AspectSorter do
  describe "concerns" do
    it_behaves_like "a_sorter", Aspect
  end
end
