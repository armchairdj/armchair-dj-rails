class User < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  devise(
    :confirmable,
    :database_authenticatable,
    :lockable,
    :recoverable,
    :registerable,
    :rememberable,
    :trackable,
    :validatable
  )

  #############################################################################
  # CLASS.
  #############################################################################

  def self.admin_scopes
    {
      "All"         => :all,
      "Member"      => :member,
      "Contributor" => :contributor,
      "Admin"       => :admin,
    }
  end

  def self.find_by_username!(username)
    find_by!(username: username, role: [:contributor, :admin])
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :alphabetical, -> { order(:first_name, :last_name) }
  scope :eager,        -> { all }
  scope :for_admin,    -> { eager }
  scope :for_site,     -> { eager }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :posts
  has_many :works,    through: :posts
  has_many :creators, through: :works

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  enum role: {
    guest:       0,
    member:      1,
    contributor: 2,
    admin:       3
  }

  enumable_attributes :role

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :first_name, presence:   true
  validates :last_name,  presence:   true

  validates :role,       presence:   true

  validates :username,   presence:   true
  validates :username,   uniqueness: true

  validates :bio, absence: true, unless: :can_contribute?

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def can_contribute?
    admin? || contributor?
  end

  def display_name
    [first_name, middle_name, last_name].compact.join(" ")
  end
end
