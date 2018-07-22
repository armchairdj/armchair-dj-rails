# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserScoper do
  describe "concerns" do
    it_behaves_like "a_scoper", User
  end
end
