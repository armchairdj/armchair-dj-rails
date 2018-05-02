# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::MediumPolicy do
  it_behaves_like "an_admin_policy" do
    let(:record) { create(:minimal_medium) }
  end

  pending "scope"
end
