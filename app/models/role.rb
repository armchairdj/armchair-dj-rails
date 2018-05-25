class Role < ApplicationRecord

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

  def self.options_for(medium)
    self.alpha.where(medium_id: medium.id)
  end

  def self.admin_sorts
    always = "roles.name ASC"

    super.merge({
      "Name"   => "#{always}, media.name ASC",
      "Medium" => "media.name ASC, #{always}",
    })
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :eager,     -> { joins(:medium).includes(:medium, :contributions, :works, :posts) }
  scope :for_admin, -> { eager }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :medium

  has_many :contributions, dependent: :destroy

  has_many :works, through: :contributions

  has_many :posts, through: :works

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :medium, presence: true
  validates :name,   presence: true

  validates :name, uniqueness: { scope: [:medium_id] }

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def alpha_parts
    [medium.try(:alpha_parts), name]
  end

  def display_name(full: false)
    return self.name unless full

    [self.medium.name, self.name].join(": ")
  end
end
