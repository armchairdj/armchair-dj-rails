# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::TagPolicy do
  it_behaves_like "an_admin_policy" do
    let(:record) { create(:minimal_tag) }
  end
end
