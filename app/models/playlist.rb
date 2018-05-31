class Playlist < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Displayable

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { includes(:tracks, :works) }
  scope :for_admin, -> { eager }
  scope :for_site,  -> { eager.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :tracks, inverse_of: :playlist, dependent: :destroy

  has_many :works, through: :tracks

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # SLUGGABLE.
  #############################################################################

  def sluggable_parts
    [title]
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

  def alpha_parts
    [title]
  end
end
