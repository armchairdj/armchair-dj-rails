# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::UserPolicy do
  it_behaves_like "an_admin_policy" do
    let(:record) { create(:minimal_user) }
  end

  pending "scope"
end
