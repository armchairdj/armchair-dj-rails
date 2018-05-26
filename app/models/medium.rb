class Medium < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MAX_ROLES_AT_ONCE  = 10.freeze
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

  has_many :facets, inverse_of: :medium, dependent: :destroy

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

  def reorder_facets!(sorted_facet_ids)
    return unless sorted_facet_ids.any?

    facets = Facet.find_by_sorted_ids(sorted_facet_ids).where(medium_id: self.id)

    unless facets.length == sorted_facet_ids.length && self.facets.count == facets.length
      raise ArgumentError.new("Bad facet reorder; ids don't match")
    end

    Facet.acts_as_list_no_update do
      facets.each.with_index(0) { |facet, i| facet.update!(position: i) }
    end
  end

  def tags_by_category
    available = categories.includes(:tags)

    return [] if available.empty?

    available.to_a
  end

  def alpha_parts
    [name]
  end
end
