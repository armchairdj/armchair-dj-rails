# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::PlaylistPolicy do
  it_behaves_like "an_admin_policy"

  describe "aliased methods" do
    subject { described_class.new(user, record) }
    let(:record) { stub_minimal_instance }
    let(:user) { build_stubbed(:user) }


    it { should have_aliased_method(:update?, :reorder_tracks?) }
  end
end
