class Track < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  acts_as_list scope: :playlist, top_of_list: 1

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :sorted,    -> { joins(:playlist, :work).order("playlist.title, tracks.position") }
  scope :eager,     -> { includes(:playlist, :work) }
  scope :for_admin, -> { eager.sorted }
  scope :for_site,  -> { eager.sorted }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :playlist, inverse_of: :tracks
  belongs_to :work,     inverse_of: :tracks

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :playlist, presence: true
  validates :work, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

end
