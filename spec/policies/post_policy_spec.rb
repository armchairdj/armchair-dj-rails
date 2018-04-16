require "rails_helper"

RSpec.describe PostPolicy do
  it_behaves_like "a public policy" do
    let(:record) { create(:minimal_post) }
  end

  pending "scope"
end