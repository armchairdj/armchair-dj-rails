# frozen_string_literal: true
# == Schema Information
#
# Table name: creator_memberships
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  member_id  :bigint(8)
#
# Indexes
#
#  index_creator_memberships_on_group_id   (group_id)
#  index_creator_memberships_on_member_id  (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => creators.id)
#  fk_rails_...  (member_id => creators.id)
#

class Creator::Membership < ApplicationRecord
  self.table_name = "creator_memberships"

  #############################################################################
  # CONCERNING: Group.
  #############################################################################

  concerning :GroupAssociation do
    included do
      belongs_to :group, class_name: "Creator", foreign_key: :group_id

      validates :group, presence: true

      validates :group_id, uniqueness: { scope: [:member_id] }

      validate { group_is_collective }
    end

  private

    def group_is_collective
      self.errors.add :group_id, :not_collective unless group.try(:collective?)
    end
  end

  #############################################################################
  # CONCERNING: Member.
  #############################################################################

  concerning :MemberAssociation do
    included do
      belongs_to :member, class_name: "Creator", foreign_key: :member_id

      validates :member, presence: true

      validate { member_is_individual }
    end

  private

    def member_is_individual
      self.errors.add :member_id, :not_individual unless member.try(:individual?)
    end
  end
end
