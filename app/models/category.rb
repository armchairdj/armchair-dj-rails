class Category < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable

  #############################################################################
  # CLASS.
  #############################################################################

  def self.admin_scopes
    {
      "All"    => :for_admin,
      "String" => :string,
      "Year"   => :year,
      "Multi"  => :multi,
      "Single" => :single,
    }
  end

  def self.admin_sorts
    always = "categories.name ASC"

    super.merge({
      "Name"   => always,
      "Format" => "categories.format ASC, #{always}",
      "Multi?" => "categories.allow_multiple ASC, #{always}"
    })
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :multi,     -> { where(allow_multiple: true ) }
  scope :single,    -> { where(allow_multiple: false) }

  scope :eager,     -> { includes(:facets, :media, :tags) }
  scope :for_admin, -> { eager }
  scope :for_site,  -> { eager.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :facets, inverse_of: :category, dependent: :destroy

  has_many :media, through: :facets

  has_many :tags, dependent: :destroy

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  enum format: {
    string: 0,
    year:   1,
  }

  enumable_attributes :format

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence: true

  validates :format, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def display_name
    allow_multiple? ? name.pluralize : name
  end

  def alpha_parts
    [name]
  end

  def multi?
    allow_multiple?
  end

  def single?
    !allow_multiple?
  end
end
