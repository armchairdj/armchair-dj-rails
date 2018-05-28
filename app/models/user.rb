# frozen_string_literal: true

class User < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable
  include Viewable

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

  def self.published_author!(username)
    viewable.where(username: username).take!
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope     :eager, -> { includes(:posts, :works, :creators) }
  scope :for_admin, -> { eager }
  scope  :for_site, -> { eager.viewable.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :posts, dependent: :destroy, foreign_key: "author_id"

  has_many :works,    through: :posts
  has_many :creators, -> { distinct }, through: :works

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  enum role: {
    member: 10,
    writer: 20,
    editor: 30,
    admin:  40,
    root:   50
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

  validates :bio, absence: true, unless: :can_write?

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def can_write?
    writer? || editor? || admin? || root?
  end

  def can_edit?
    editor? || admin? || root?
  end

  def can_publish?
    admin? || root?
  end

  def can_destroy?
    root?
  end

  def display_name
    [first_name, middle_name, last_name].compact.join(" ")
  end

  def alpha_parts
    [last_name, first_name, middle_name]
  end
end
