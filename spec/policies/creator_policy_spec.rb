# frozen_string_literal: true

require "rails_helper"

RSpec.describe CreatorPolicy do
  it_behaves_like "a_public_policy" do
    let(:record) { create(:minimal_creator) }
  end
end
