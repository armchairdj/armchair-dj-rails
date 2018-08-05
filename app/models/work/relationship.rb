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

class Work::Relationship < ApplicationRecord
  self.table_name = "work_relationships"

  #############################################################################
  # CONCERNING: Target.
  #############################################################################

  belongs_to :target, class_name: "Work", foreign_key: :target_id

  validates :target, presence: true

  validates :target_id, uniqueness: { scope: [:source_id, :connection] }

  #############################################################################
  # CONCERNING: Connection.
  #############################################################################

  enum connection: {
    is_a_version_of:      100,
    is_a_performance_of:  101,

    is_a_remake_of:       200,
    is_a_sequel_to:       201,
    is_a_spinoff_of:      202,

    borrows_from:         300,

    is_a_member_of:       400,
  }

  enumable_attributes :connection

  #############################################################################
  # CONCERNING: Source.
  #############################################################################

  belongs_to :source, class_name: "Work", foreign_key: :source_id

  validates :source, presence: true
end
