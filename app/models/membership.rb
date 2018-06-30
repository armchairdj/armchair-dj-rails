# frozen_string_literal: true

# == Schema Information
#
# Table name: memberships
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :bigint(8)
#  member_id  :bigint(8)
#
# Indexes
#
#  index_memberships_on_group_id   (group_id)
#  index_memberships_on_member_id  (member_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => creators.id)
#  fk_rails_...  (member_id => creators.id)
#


class Membership < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :group,  class_name: "Creator", foreign_key: :group_id
  belongs_to :member, class_name: "Creator", foreign_key: :member_id

  #############################################################################
  # ATTRIBUTES.
  #############################################################################
  
  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :group,   presence: true
  validates :member,  presence: true

  validates :group_id, uniqueness: { scope: [:member_id] }

  def group_is_collective
    self.errors.add :group_id, :not_collective unless group.try(:collective?)
  end

  private :group_is_collective

  validate { group_is_collective }

  def member_is_individual
    self.errors.add :member_id, :not_individual unless member.try(:individual?)
  end

  private :member_is_individual

  validate { member_is_individual }

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

end
