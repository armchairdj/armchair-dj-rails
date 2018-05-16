class Medium < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MAX_ROLES_AT_ONCE = 10.freeze
  MAX_FACETS_AT_ONCE = 10.freeze

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

  scope :eager,     -> { includes(:roles, :works, :posts, :facets, :categories, :tags) }
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

  has_many :facets, -> { includes(:category).order("categories.name") }, inverse_of: :medium, dependent: :destroy

  has_many :categories, through: :facets
  has_many :tags,       through: :categories

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :roles, allow_destroy: true,
    reject_if: proc { |attrs| attrs["name"].blank? }

  def prepare_roles
    MAX_ROLES_AT_ONCE.times { self.roles.build }
  end

  accepts_nested_attributes_for :facets, allow_destroy: :true,
    reject_if: proc { |attrs| attrs["category_id"].blank? }

  def prepare_facets
    MAX_FACETS_AT_ONCE.times { self.facets.build }
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence:   true
  validates :name, uniqueness: true

  validate { at_least_one_role }

  def at_least_one_role
    return if self.roles.reject(&:marked_for_destruction?).any?

    self.errors.add(:roles, :missing)
  end

  private :at_least_one_role

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def tags_by_category
    available = tags.alpha.includes(:category)

    return [] if available.empty?

    available.group_by{ |t| t.category }.to_a
  end

  def alpha_parts
    [name]
  end
end
