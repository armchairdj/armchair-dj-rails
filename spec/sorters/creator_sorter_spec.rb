# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatorSorter do
  describe "concerns" do
    it_behaves_like "a_sorter", Creator
  end
end
