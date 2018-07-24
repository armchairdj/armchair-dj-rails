# frozen_string_literal: true

# == Schema Information
#
# Table name: memberships
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  member_id  :bigint(8)
#
# Indexes
#
#  index_memberships_on_group_id   (group_id)
#  index_memberships_on_member_id  (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => creators.id)
#  fk_rails_...  (member_id => creators.id)
#


require "rails_helper"

RSpec.describe Membership do
  describe "concerns" do
    it_behaves_like "an_application_record"
  end

  describe "associations" do
    it { is_expected.to belong_to(:group ).class_name("Creator") }
    it { is_expected.to belong_to(:member).class_name("Creator") }
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:group ) }
    it { is_expected.to validate_presence_of(:member) }

    it { is_expected.to validate_uniqueness_of(:group_id).scoped_to(:member_id) }

    describe "custom" do
      subject { create_minimal_instance }

      describe "#group_is_collective" do
        before(:each) do
          expect(subject).to receive(:group_is_collective).and_call_original
        end

        specify "valid" do
          is_expected.to be_valid
        end

        specify "invalid" do
          subject.group = create(:individual_creator)

          is_expected.to_not be_valid

          is_expected.to have_error(group_id: :not_collective)
        end
      end

      describe "#member_is_individual" do
        before(:each) do
          expect(subject).to receive(:member_is_individual).and_call_original
        end

        specify "valid" do
          is_expected.to be_valid
        end

        specify "invalid" do
          subject.member = create(:collective_creator)

          is_expected.to_not be_valid

          is_expected.to have_error(member_id: :not_individual)
        end
      end
    end
  end
end
