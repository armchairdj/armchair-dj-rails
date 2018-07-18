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

    describe "nilify_blanks" do
      subject { create_minimal_instance }

      describe "nilify_blanks" do
        it { is_expected.to nilify_blanks(before: :validation) }
      end
    end
  end

  describe "class" do
    # Nothing so far.
  end

  describe "scope-related" do
    describe "basics" do
      let(       :ids) { create_list(:minimal_milestone, 3).map(&:id) }
      let(:collection) { described_class.where(id: ids) }
      let(:list_loads) { [] }
      let(:show_loads) { [:work] }

      describe "self#for_show" do
        subject { collection.for_show }

        it { is_expected.to eager_load(show_loads) }
        it { is_expected.to contain_exactly(*collection.to_a) }
      end

      describe "self#for_list" do
        subject { collection.for_list }

        it { is_expected.to eager_load(list_loads) }
        it { is_expected.to contain_exactly(*collection.to_a) }
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
    pending "#posts"
  end
end
