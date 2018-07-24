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

RSpec.describe Contribution do
  describe "concerns" do
    it_behaves_like "an_application_record"

    it_behaves_like "an_alphabetizable_model"

    it_behaves_like "a_contributable_model"

    it_behaves_like "an_eager_loadable_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [:work, :role, :creator] }
    end

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      it { is_expected.to nilify_blanks(before: :validation) }
    end
  end

  describe "validations" do
    subject { build_minimal_instance }

    it { is_expected.to validate_uniqueness_of(:creator_id).scoped_to(:work_id, :role_id) }

    describe "role" do
      subject { build_minimal_instance(work_id: create(:minimal_song).id) }

      let!(:song_role_ids) { 3.times.map { |i| create(:minimal_role, medium: "Song").id } }

      it { is_expected.to validate_presence_of(:role_id) }

      it { is_expected.to validate_inclusion_of(:role_id).in_array(song_role_ids) }
    end
  end
end
