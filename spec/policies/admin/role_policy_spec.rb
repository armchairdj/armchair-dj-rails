# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::RolePolicy do
  it_behaves_like "an_admin_policy" do
    let(:record) { create(:minimal_role) }
  end

  pending "scope"
end
