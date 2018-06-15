# frozen_string_literal: true

class User < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Alphabetizable
  include Linkable
  include Sluggable

  #############################################################################
  # PLUGINS.
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

  #############################################################################
  # SCOPES.
  #############################################################################

  scope     :eager, -> { includes(:articles, :reviews, :mixtapes, :works, :creators) }
  scope :for_admin, -> { eager }
  scope  :for_site, -> { eager.viewable.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :posts,     dependent: :destroy, foreign_key: "author_id"
  has_many :articles,  dependent: :destroy, foreign_key: "author_id"
  has_many :reviews,   dependent: :destroy, foreign_key: "author_id"
  has_many :mixtapes,  dependent: :destroy, foreign_key: "author_id"
  has_many :playlists, dependent: :destroy, foreign_key: "author_id"

  has_many :works, through: :reviews
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


  def to_param
    username
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :first_name, presence:   true
  validates :last_name,  presence:   true

  validates :role,       presence:   true

  validates :username,   presence:   true
  validates :username,   uniqueness: true
  validates :username,   format: { with: /\A[a-zA-Z]+\z/ }

  validates :bio, absence: true, unless: :can_write?

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def can_write?
    root? || admin? || editor? || writer?
  end

  def can_edit?
    root? || admin? || editor?
  end

  def can_publish?
    root? || admin?
  end
  alias_method :can_administer?, :can_publish?

  def can_destroy?
    root?
  end

  def display_name
    [first_name, middle_name, last_name].compact.join(" ")
  end

  def assignable_role_options
    return [] unless self.can_administer?

    options = self.class.human_roles

    options.slice(0..options.index { |o| o.last == self.role })
  end

  def valid_role_assignment_for?(instance)
    return true if instance.role.blank?
    return true if self.assignable_role_options.map(&:last).include?(instance.role)

    instance.errors.add(:role, :invalid_assignment)

    false
  end

  def alpha_parts
    [last_name, first_name, middle_name]
  end
end
