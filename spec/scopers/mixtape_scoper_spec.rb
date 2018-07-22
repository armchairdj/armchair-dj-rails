# frozen_string_literal: true

require "rails_helper"

RSpec.describe MixtapeScoper do
  describe "concerns" do
    it_behaves_like "a_scoper", Mixtape
  end
end
