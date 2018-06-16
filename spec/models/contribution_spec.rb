# frozen_string_literal: true

require "rails_helper"

RSpec.describe Contribution, type: :model do
  context "concerns" do
    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "an_application_record"

    it_behaves_like "a_contributable_model"
  end

  context "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_uniqueness_of(:creator_id).scoped_to(:work_id, :role_id) }

    describe "role" do
      subject { create_minimal_instance(work_id: create(:minimal_song).id) }

      let!(:song_role_ids) { 3.times.map { |i| create(:minimal_role, work_type: "Song").id } }

      it { is_expected.to validate_presence_of(:role_id) }

      it { is_expected.to validate_inclusion_of(:role_id).in_array(song_role_ids) }
    end
  end

  context "instance" do
    let(:instance) { create_minimal_instance }

    describe "#alpha_parts" do
      subject { instance.alpha_parts }

      it { is_expected.to eq([
        instance.work.alpha_parts,
        instance.role.name,
        instance.creator.name
      ]) }
    end
  end
end
