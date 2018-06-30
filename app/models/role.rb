# == Schema Information
#
# Table name: roles
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  name       :string
#  work_type  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_roles_on_alpha      (alpha)
#  index_roles_on_work_type  (work_type)
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

  scope :eager,     -> { includes(:contributions, :works) }
  scope :for_admin, -> { eager }

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

  validates :work_type, presence: true
  validates :work_type, inclusion: { in: Work.valid_types }

  validates :name, presence: true
  validates :name, uniqueness: { scope: [:work_type] }

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
    return unless work_type

    work_type.constantize.true_human_model_name
  end
end
