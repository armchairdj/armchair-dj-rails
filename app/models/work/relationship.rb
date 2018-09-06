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
  # CONCERNING: Source.
  #############################################################################

  concerning :SourceAssociation do
    included do
      belongs_to :source, class_name: "Work", foreign_key: :source_id

      validates :source, presence: true

      validates :source_id, uniqueness: { scope: [:target_id, :connection] }

      validate { source_and_target_are_different }
    end

  private

    def source_and_target_are_different
      return unless source_id == target_id

      self.errors.add(:source_id, :same_as_target)
    end
  end

  #############################################################################
  # CONCERNING: Target.
  #############################################################################

  concerning :TargetAssociation do
    included do
      belongs_to :target, class_name: "Work", foreign_key: :target_id

      validates :target, presence: true
    end
  end

  #############################################################################
  # CONCERNING: Connection.
  #############################################################################

  concerning :ConnectionAttribute do
    included do
      validates :connection, presence: true

      enum connection: {
        member_of:       100,

        version_of:      200,
        performance_of:  201,

        remake_of:       300,
        sequel_to:       301,
        spinoff_of:      302,

        borrows_from:    400,
      }

      improve_enum :connection
    end
  end
end
