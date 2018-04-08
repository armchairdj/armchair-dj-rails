require 'rails_helper'

RSpec.describe Admin::UserPolicy do
  it_behaves_like "an admin policy" do
    let(:record) { create(:minimal_user) }
  end
end