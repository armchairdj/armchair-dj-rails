require 'rails_helper'

RSpec.describe Admin::CreatorPolicy do
  it_behaves_like "an admin policy" do
    let(:record) { create(:minimal_creator) }
  end

  pending "scope"
end