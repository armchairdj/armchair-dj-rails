# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReviewScoper do
  describe "concerns" do
    it_behaves_like "a_scoper", Review
  end
end
