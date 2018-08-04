# frozen_string_literal: true

# == Schema Information
#
# Table name: work_versionings
#
#  id          :bigint(8)        not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  original_id :bigint(8)
#  revision_id :bigint(8)
#
# Indexes
#
#  index_work_versionings_on_original_id  (original_id)
#  index_work_versionings_on_revision_id  (revision_id)
#
# Foreign Keys
#
#  fk_rails_...  (original_id => works.id)
#  fk_rails_...  (revision_id => works.id)
#


class Work::Versioning < ApplicationRecord
  self.table_name = "work_versionings"

  #############################################################################
  # CONCERNING: Original.
  #############################################################################

  belongs_to :original, class_name: "Work", foreign_key: :original_id

  validates :original, presence: true

  #############################################################################
  # CONCERNING: Revision.
  #############################################################################

  belongs_to :revision, class_name: "Work", foreign_key: :revision_id

  validates :revision, presence: true

  validates :revision_id, uniqueness: { scope: [:original_id] }
end
