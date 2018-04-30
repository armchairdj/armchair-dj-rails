# frozen_string_literal: true

class Identity < ApplicationRecord

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

  belongs_to :creator
  belongs_to :pseudonym, class_name: "Creator"

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :creator,    presence: true
  validates :pseudonym,  presence: true

  validates :creator_id,   uniqueness: { scope: [:pseudonym_id] }
  validates :pseudonym_id, uniqueness: true

  validate { creator_is_primary }

  def creator_is_primary
    puts ">>creator_is_primary", creator.inspect

    return if creator.try(:primary?)

    self.errors.add :creator_id, :not_primary
  end

  private :creator_is_primary

  validate { pseudonym_is_secondary }

  def pseudonym_is_secondary
    puts ">>pseudonym_is_secondary", pseudonym.inspect

    return if pseudonym.try(:secondary?)

    self.errors.add :pseudonym_id, :not_secondary
  end

  private :pseudonym_is_secondary

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

private

end
