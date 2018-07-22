# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagScoper do
  describe "concerns" do
    it_behaves_like "a_scoper", Tag
  end
end
