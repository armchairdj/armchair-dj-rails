# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatorScoper do
  describe "concerns" do
    it_behaves_like "a_scoper", Creator
  end
end
