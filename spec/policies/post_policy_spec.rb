require "rails_helper"

RSpec.describe PostPolicy do
  it_behaves_like "a_public_policy" do
    let(:record) { create(:minimal_post) }
  end

  pending "scope"
end