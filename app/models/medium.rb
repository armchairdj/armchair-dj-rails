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

  def self.admin_scopes
    {
      "All"          => :for_admin,
      "Viewable"     => :viewable,
      "Non-Viewable" => :non_viewable,
    }
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { includes(:roles, :works) }
  scope :for_admin, -> { eager }
  scope :for_site,  -> { viewable.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :roles,  dependent: :destroy
  has_many :works,  dependent: :destroy

  has_many :creators, -> { distinct }, through: :works

  has_many :posts, through: :works

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence:   true
  validates :name, uniqueness: true

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
