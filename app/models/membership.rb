# frozen_string_literal: true

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

  belongs_to :creator, required: true
  belongs_to :member,  required: true, class_name: "Creator"

  #############################################################################
  # ATTRIBUTES.
  #############################################################################
  
  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :creator, presence: true
  validates :member,  presence: true

  validates :creator_id, uniqueness: { scope: [:member_id] }

  validate { creator_is_collective }
  validate { member_is_singular }

  def creator_is_collective
    return if creator.try(:collective?)

    self.errors.add :creator_id, :not_collective
  end

  def member_is_singular
    return if member.try(:singular?)

    self.errors.add :member_id, :not_singular
  end

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

private

end
