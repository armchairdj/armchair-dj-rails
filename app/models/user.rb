class User < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS & PLUGINS.
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
  # ASSOCIATIONS.
  #############################################################################

  #############################################################################
  # NESTED ATTRIBUTES.
  #############################################################################

  #############################################################################
  # ENUMS.
  #############################################################################

  enum role: {
    guest:       0,
    member:      1,
    contributor: 2,
    admin:       3
  }

  #############################################################################
  # SCOPES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :first_name, presence: true

  validates :last_name, presence: true

  validates :role, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  before_validation :set_default_role, if: :new_record?

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def display_name
    [first_name, last_name].compact.join(" ")
  end

private

  def set_default_role
    self.role = :guest if self.role.nil?
  end

end
