# frozen_string_literal: true

require "rails_helper"

RSpec.describe RoleSorter do
  describe "concerns" do
    it_behaves_like "a_sorter", Role
  end
end
