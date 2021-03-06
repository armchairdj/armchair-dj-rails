# frozen_string_literal: true

# == Schema Information
#
# Table name: creator_identities
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pseudonym_id :bigint(8)
#  real_name_id :bigint(8)
#
# Indexes
#
#  index_creator_identities_on_pseudonym_id  (pseudonym_id)
#  index_creator_identities_on_real_name_id  (real_name_id)
#
# Foreign Keys
#
#  fk_rails_...  (pseudonym_id => creators.id)
#  fk_rails_...  (real_name_id => creators.id)
#

require "rails_helper"

RSpec.describe Creator::Identity do
  describe "ApplicationRecord" do
    it_behaves_like "an_application_record"
  end

  describe ":PseudonymAssociation" do
    subject { build_minimal_instance }

    it { is_expected.to belong_to(:pseudonym).class_name("Creator").required }

    it { is_expected.to validate_presence_of(:pseudonym) }

    it { is_expected.to validate_uniqueness_of(:pseudonym_id) }

    describe "validates #pseudonym_is_secondary" do
      let(:instance) { build_minimal_instance }

      before do
        expect(instance).to receive(:pseudonym_is_secondary).and_call_original
      end

      specify "valid" do
        expect(instance).to be_valid
      end

      specify "invalid" do
        instance.pseudonym = create(:primary_creator)

        expect(instance).to_not be_valid
        expect(instance).to have_error(pseudonym_id: :not_secondary)
      end
    end
  end

  describe ":RealNameAssociation" do
    subject { build_minimal_instance }

    it { is_expected.to belong_to(:real_name).class_name("Creator").required }

    it { is_expected.to validate_presence_of(:real_name) }

    it { is_expected.to validate_uniqueness_of(:real_name_id).scoped_to(:pseudonym_id) }

    describe "validates #real_name_is_primary" do
      let(:instance) { build_minimal_instance }

      before do
        expect(instance).to receive(:real_name_is_primary).and_call_original
      end

      specify "valid" do
        expect(instance).to be_valid
      end

      specify "invalid" do
        instance.real_name = create(:secondary_creator)

        expect(instance).to_not be_valid
        expect(instance).to have_error(real_name_id: :not_primary)
      end
    end
  end
end
