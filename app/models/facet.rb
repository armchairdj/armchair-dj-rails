class Facet < ApplicationRecord

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

  belongs_to :medium,   inverse_of: :facets
  belongs_to :category, inverse_of: :facets

  # acts_as_list scope: [:medium_id]

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :medium,   presence: true
  validates :category, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

end
