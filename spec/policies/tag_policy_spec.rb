# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagPolicy do
  it_behaves_like "a_public_policy" do
    let(:record) { create(:minimal_tag) }
  end

  pending "scope"
end