# frozen_string_literal: true

# == Schema Information
#
# Table name: work_relationships
#
#  id         :bigint(8)        not null, primary key
#  connection :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  source_id  :bigint(8)        not null
#  target_id  :bigint(8)        not null
#
# Indexes
#
#  index_work_relationships_on_source_id  (source_id)
#  index_work_relationships_on_target_id  (target_id)
#
# Foreign Keys
#
#  fk_rails_...  (source_id => works.id)
#  fk_rails_...  (target_id => works.id)
#

require "rails_helper"

RSpec.describe Work::Relationship do
  describe "ApplicationRecord" do
    it_behaves_like "an_application_record"
  end

  describe ":ConnectionAttribute" do
    it { is_expected.to validate_presence_of(:connection) }

    it_behaves_like "a_model_with_a_better_enum_for",
      attribute:  :connection,
      variations: [:source, :target]
  end

  describe ":SourceAssociation" do
    subject { create_minimal_instance }

    it { is_expected.to belong_to(:source).class_name("Work") }

    it { is_expected.to validate_presence_of(:source) }

    it { is_expected.to validate_uniqueness_of(:source_id).scoped_to(:target_id, :connection) }
  end

  describe ":TargetAssociation" do
    it { is_expected.to belong_to(:target).class_name("Work") }

    it { is_expected.to validate_presence_of(:target) }
  end
end
