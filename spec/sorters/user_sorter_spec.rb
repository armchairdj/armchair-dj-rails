# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserSorter do
  describe "concerns" do
    it_behaves_like "a_sorter", User
  end
end
