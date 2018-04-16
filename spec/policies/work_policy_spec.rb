require "rails_helper"

RSpec.describe WorkPolicy do
  it_behaves_like "a public policy" do
    let(:record) { create(:minimal_work) }
  end

  pending "scope"
end