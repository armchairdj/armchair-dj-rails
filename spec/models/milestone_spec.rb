# == Schema Information
#
# Table name: milestones
#
#  id         :bigint(8)        not null, primary key
#  activity   :integer          not null
#  year       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  work_id    :bigint(8)
#
# Indexes
#
#  index_milestones_on_activity  (activity)
#  index_milestones_on_work_id   (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#

require "rails_helper"

RSpec.describe Milestone, type: :model do
  describe "constants" do
    # Nothing so far.
  end

  describe "concerns" do
    it_behaves_like "an_application_record"
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    describe "basics" do
      let(:remastered) { create(:minimal_milestone, activity: :remastered, year: 2005) }
      let(  :released) { create(:minimal_milestone, activity: :released,   year: 1977) }
      let(  :reissued) { create(:minimal_milestone, activity: :reissued,   year: 2017) }
      let(       :ids) { [remastered, released, reissued].map(&:id) }
      let(:collection) { described_class.where(id: ids) }

      describe "self#eager" do
        subject { collection.eager }

        it { is_expected.to eager_load(:work) }
        it { is_expected.to match_array(collection.to_a) }
      end

      describe "self#for_admin" do
        subject { collection.for_admin.where(id: ids) }

        it { is_expected.to eager_load(:work) }
        it { is_expected.to match_array(collection.to_a) }
      end
    end
  end

  describe "associations" do
    it { is_expected.to belong_to(:work) }
  end

  describe "attributes" do
    describe "enums" do
      it_behaves_like "an_enumable_model", [:activity]
    end
  end

  describe "validations" do
    subject { create_minimal_instance }

    it { is_expected.to validate_presence_of(:work) }

    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_yearness_of(:year) }

    it { is_expected.to validate_presence_of(:activity) }
  end

  describe "hooks" do
    # Nothing so far.
  end

  describe "instance" do
    # Nothing so far.
  end
end
