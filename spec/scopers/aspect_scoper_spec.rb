# frozen_string_literal: true

require "rails_helper"

RSpec.describe AspectScoper do
  describe "concerns" do
    it_behaves_like "a_scoper", Aspect
  end
end
