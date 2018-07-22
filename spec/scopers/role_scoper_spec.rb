# frozen_string_literal: true

require "rails_helper"

RSpec.describe RoleScoper do
  describe "concerns" do
    it_behaves_like "a_scoper", Role
  end
end
