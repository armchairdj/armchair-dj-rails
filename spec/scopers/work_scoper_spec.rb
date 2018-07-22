# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorkScoper do
  describe "concerns" do
    it_behaves_like "a_scoper", Work
  end
end
