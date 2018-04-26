require "rails_helper"

RSpec.describe Admin::WorkPolicy do
  it_behaves_like "an_admin_policy" do
    let(:record) { create(:minimal_work) }
  end

  pending "scope"
end