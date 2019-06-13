# frozen_string_literal: true

# == Schema Information
#
# Table name: attributions
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  position   :integer
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :bigint(8)
#  role_id    :bigint(8)
#  work_id    :bigint(8)
#
# Indexes
#
#  index_attributions_on_alpha       (alpha)
#  index_attributions_on_creator_id  (creator_id)
#  index_attributions_on_role_id     (role_id)
#  index_attributions_on_work_id     (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => creators.id)
#  fk_rails_...  (role_id => roles.id)
#  fk_rails_...  (work_id => works.id)
#

require "rails_helper"

RSpec.describe Contribution do
  describe "ApplicationRecord" do
    it_behaves_like "an_application_record"

    describe "nilify_blanks" do
      subject { build_minimal_instance }

      # Must specify individual fields for STI models.
      it { is_expected.to nilify_blanks_for(:alpha, before: :validation) }
    end
  end

  describe ":CreatorAssociation" do
    subject { create_minimal_instance }

    it { is_expected.to validate_uniqueness_of(:creator_id).scoped_to(:work_id, :role_id) }
  end

  describe ":GinsuIntegration" do
    it_behaves_like "a_ginsu_model" do
      let(:list_loads) { [] }
      let(:show_loads) { [:work, :role, :creator] }
    end
  end

  describe ":RoleAssociation" do
    it { is_expected.to belong_to(:role).required }

    pending "#role_name"

    describe "validation" do
      subject { build_minimal_instance(work_id: create(:minimal_song).id) }

      let!(:song_role_ids) { create_list(:minimal_role, 3, medium: "Song").map(&:id) }

      it { is_expected.to validate_presence_of(:role_id) }

      it { is_expected.to validate_inclusion_of(:role_id).in_array(song_role_ids) }
    end
  end

  describe ":StiInheritance" do
    it_behaves_like "an_attribution"
  end
end
