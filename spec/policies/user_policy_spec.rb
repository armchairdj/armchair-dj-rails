# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserPolicy do
  it_behaves_like "a_public_policy" do
    let(:record) { create(:member) }
  end

  pending "scope"
end
