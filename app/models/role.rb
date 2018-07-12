# == Schema Information
#
# Table name: roles
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  medium     :string           not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_roles_on_alpha   (alpha)
#  index_roles_on_medium  (medium)
#

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

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :for_medium, -> (medium) { where(medium: medium) }
  scope :eager,      -> { includes(:contributions, :works) }
  scope :for_admin,  -> { eager }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :contributions, dependent: :destroy

  has_many :works, through: :contributions

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :medium, presence: true
  validates :medium, inclusion: { in: Work.valid_media }

  validates :name, presence: true
  validates :name, uniqueness: { scope: [:medium] }

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def alpha_parts
    [display_medium, name]
  end

  def display_name(full: false)
    full ? [display_medium, name].join(": ") : name
  end

  def display_medium
    return unless medium

    medium.constantize.display_medium
  end
end
