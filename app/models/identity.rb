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

  belongs_to :real_name, class_name: "Creator", foreign_key: :real_name_id
  belongs_to :pseudonym, class_name: "Creator", foreign_key: :pseudonym_id

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :real_name,  presence: true
  validates :pseudonym,  presence: true

  validates :real_name_id, uniqueness: { scope: [:pseudonym_id] }
  validates :pseudonym_id, uniqueness: true

  validate { real_name_is_primary }

  def real_name_is_primary
    return if real_name.try(:primary?)

    self.errors.add :real_name_id, :not_primary
  end

  private :real_name_is_primary

  validate { pseudonym_is_secondary }

  def pseudonym_is_secondary
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

end
