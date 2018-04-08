require 'rails_helper'

RSpec.describe CreatorPolicy do
  it_behaves_like "a public policy" do
    let(:record) { create(:minimal_creator) }
  end

  pending "scope"
end
