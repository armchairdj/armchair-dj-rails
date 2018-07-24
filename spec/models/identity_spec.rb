# frozen_string_literal: true

# == Schema Information
#
# Table name: identities
#
#  id           :bigint(8)        not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  pseudonym_id :bigint(8)
#  real_name_id :bigint(8)
#
# Indexes
#
#  index_identities_on_pseudonym_id  (pseudonym_id)
#  index_identities_on_real_name_id  (real_name_id)
#
# Foreign Keys
#
#  fk_rails_...  (pseudonym_id => creators.id)
#  fk_rails_...  (real_name_id => creators.id)
#


require "rails_helper"

RSpec.describe Identity do
  describe "concerns" do
    it_behaves_like "an_application_record"
  end

  describe "associations" do
    it { is_expected.to belong_to(:real_name).class_name("Creator") }
    it { is_expected.to belong_to(:pseudonym).class_name("Creator") }
  end

  describe "validations" do
    subject { build_minimal_instance }

    it { is_expected.to validate_presence_of(:real_name) }
    it { is_expected.to validate_presence_of(:pseudonym) }

    it { is_expected.to validate_uniqueness_of(:real_name_id).scoped_to(:pseudonym_id) }

    describe "custom" do
      subject { build_minimal_instance }

      describe "#real_name_is_primary" do
        before(:each) do
          expect(subject).to receive(:real_name_is_primary).and_call_original
        end

        specify "valid" do
          is_expected.to be_valid
        end

        specify "invalid" do
          subject.real_name = create(:secondary_creator)

          is_expected.to_not be_valid

          is_expected.to have_error(real_name_id: :not_primary)
        end
      end

      describe "#pseudonym_is_secondary" do
        before(:each) do
          expect(subject).to receive(:pseudonym_is_secondary).and_call_original
        end

        specify "valid" do
          is_expected.to be_valid
        end

        specify "invalid" do
          subject.pseudonym = create(:primary_creator)

          is_expected.to_not be_valid

          is_expected.to have_error(pseudonym_id: :not_secondary)
        end
      end
    end
  end
end
