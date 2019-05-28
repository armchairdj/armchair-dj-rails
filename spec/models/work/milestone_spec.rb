# frozen_string_literal: true

# == Schema Information
#
# Table name: work_milestones
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
#  index_work_milestones_on_activity  (activity)
#  index_work_milestones_on_work_id   (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_id => works.id)
#

require "rails_helper"

RSpec.describe Work::Milestone do
  it_behaves_like "an_application_record"

  it_behaves_like "a_ginsu_model" do
    let(:list_loads) { [] }
    let(:show_loads) { [:work] }
  end

  describe "nilify_blanks" do
    subject { build_minimal_instance }

    it { is_expected.to nilify_blanks(before: :validation) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:work).required }
  end

  describe "attributes" do
    describe "enums" do
      it_behaves_like "a_model_with_a_better_enum_for", :activity
    end
  end

  describe "validations" do
    subject { build_minimal_instance }

    it { is_expected.to validate_presence_of(:work) }

    it { is_expected.to validate_presence_of(:year) }
    it { is_expected.to validate_yearness_of(:year) }

    it { is_expected.to validate_presence_of(:activity) }
  end
end
