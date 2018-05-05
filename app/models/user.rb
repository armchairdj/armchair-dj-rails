# frozen_string_literal: true

class User < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable

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
      "All"         => :for_admin,
      "Member"      => :member,
      "Writer"      => :writer,
      "Editor"      => :editor,
      "Admin"       => :admin,
      "Super Admin" => :super_admin
    }
  end

  def self.published_author!(username)
    published.where(username: username).take!
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :published, -> {
    left_outer_joins(:posts)
      .where(    posts: { status: Post.statuses[:published] })
      .where.not(posts: { id: nil })
      .where(     role: [:writer, :editor, :admin, :super_admin])
  }

  scope :eager, -> { includes(:posts, :works, :creators) }

  scope :for_admin, -> { eager }
  scope  :for_site, -> { eager.published.alpha }

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
    member:      10,
    writer:      20,
    editor:      30,
    admin:       40,
    super_admin: 50
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

  validates :bio, absence: true, unless: :can_post?

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def can_administer?
    admin? || super_admin?
  end

  def can_post?
    writer? || editor? || admin? || super_admin?
  end

  def display_name
    [first_name, middle_name, last_name].compact.join(" ")
  end

  def alpha_parts
    [last_name, first_name, middle_name]
  end
end
