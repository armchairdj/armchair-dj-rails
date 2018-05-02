class Genre < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable
  include Summarizable
  # include Viewable

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { all }
  scope :for_admin, -> { eager }
  scope :for_site,  -> { alpha } # todo viewable

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :medium

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def alpha_parts
    [medium.try(:alpha_parts), name]
  end
end
