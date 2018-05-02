# frozen_string_literal: true

require "rails_helper"

RSpec.describe MediumPolicy do
  it_behaves_like "a_public_policy" do
    let(:record) { create(:minimal_medium) }
  end

  pending "scope"
end
