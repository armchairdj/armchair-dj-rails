class SongContribution < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS & PLUGINS.
  #############################################################################

  include Contribution

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :artist, required: true
  belongs_to :song, required: true

  #############################################################################
  # ENUMS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  #############################################################################
  # CLASS.
  #############################################################################

end