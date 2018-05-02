# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorkPolicy do
  it_behaves_like "a_public_policy" do
    let(:record) { create(:minimal_work) }
  end

  pending "scope"
end
