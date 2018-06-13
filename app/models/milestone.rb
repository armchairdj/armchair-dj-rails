class Milestone < ApplicationRecord

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

  scope :sorted,    -> { order(:year) }
  scope :eager,     -> { includes(:work) }
  scope :for_admin, -> { eager }
  scope :for_site,  -> { eager.sorted }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :work

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  enum action: {
    released:    0,
    published:   1,
    aired:       2,

    created:    10,

    reissued:   20,
    rereleased: 21,
    remastered: 22,
    recut:      23,
    remixed:    24
  }

  enumable_attributes :action

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :work, presence: true

  validates :action, presence: true

  validates :year, presence: true, yearness: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

end