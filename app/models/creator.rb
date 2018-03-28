class Creator < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS & PLUGINS.
  #############################################################################

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :contributions

  has_many :works, -> { where(contributions: {
    role: Contribution.roles["creator"] })
  }, through: :contributions, source: :work, class_name: "Work"

  has_many :contributed_works, -> { where.not(contributions: {
    role: Contribution.roles["creator"] })
  }, through: :contributions, source: :work, class_name: "Work"

  has_many :posts, through: :works

  #############################################################################
  # NESTED ATTRIBUTES.
  #############################################################################

  #############################################################################
  # ENUMS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :alphabetical, -> { order(:name) }

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

end
