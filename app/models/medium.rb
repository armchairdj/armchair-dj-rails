class Medium < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable
  include Summarizable
  include Viewable

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { includes(:genres, :roles, :works) }
  scope :for_admin, -> { eager }
  scope :for_site,  -> { viewable.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :genres, dependent: :destroy
  has_many :roles,  dependent: :destroy
  has_many :works,  dependent: :destroy

  has_many :posts, through: :works

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
    [name]
  end
end
