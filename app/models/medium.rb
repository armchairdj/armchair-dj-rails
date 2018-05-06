class Medium < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MAX_ROLES_AT_ONCE  = 10.freeze

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

  has_many :creators,     -> { distinct }, through: :works
  has_many :contributors, -> { distinct }, through: :works

  has_many :posts, through: :works

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :roles, allow_destroy: true,
    reject_if: proc { |attrs| attrs["name"].blank? }

  def prepare_roles
    MAX_ROLES_AT_ONCE.times { self.roles.build }
  end

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
