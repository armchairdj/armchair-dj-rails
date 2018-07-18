# frozen_string_literal: true

# == Schema Information
#
# Table name: contributions
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :bigint(8)
#  role_id    :bigint(8)
#  work_id    :bigint(8)
#
# Indexes
#
#  index_contributions_on_alpha       (alpha)
#  index_contributions_on_creator_id  (creator_id)
#  index_contributions_on_role_id     (role_id)
#  index_contributions_on_work_id     (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#


require "rails_helper"

RSpec.describe Contribution, type: :model do
  describe "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "a_contributable_model"

    describe "nilify_blanks" do
      subject { create_minimal_instance }

      describe "nilify_blanks" do
        it { is_expected.to nilify_blanks(before: :validation) }
      end
    end
  end

  describe "scope-related" do
    let!(:with_published) { create_minimal_instance }
    let!(:with_scheduled) { create_minimal_instance }
    let!(:with_draft    ) { create_minimal_instance }
    let!(:with_none     ) { create_minimal_instance }

    let(:ids) { [with_published, with_scheduled, with_draft, with_none].map(&:id) }

    before(:each) do
      create(:minimal_review, :published, work: with_published.work)
      create(:minimal_review, :scheduled, work: with_scheduled.work)
      create(:minimal_review, :draft,     work:     with_draft.work)
    end

    describe "self#for_show" do
      subject { described_class.for_show.where(id: ids) }

      it { is_expected.to eager_load(:work, :role, :creator) }
    end

    pending "self#for_list"
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_uniqueness_of(:creator_id).scoped_to(:work_id, :role_id) }

    describe "role" do
      subject { create_minimal_instance(work_id: create(:minimal_song).id) }

      let!(:song_role_ids) { 3.times.map { |i| create(:minimal_role, medium: "Song").id } }

      it { is_expected.to validate_presence_of(:role_id) }

      it { is_expected.to validate_inclusion_of(:role_id).in_array(song_role_ids) }
    end
  end

  describe "instance" do
    let(:instance) { create_minimal_instance }
  end
end
