# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PostPolicy do
  it_behaves_like "an_admin_policy" do
    let(:record) { create(:minimal_post) }
  end

  pending "scope"
end