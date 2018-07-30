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
  # CONCERNS.
  #############################################################################

  include Alphabetizable

  #############################################################################
  # CONCERNING: Medium
  #############################################################################

  concerning :Medium do
    included do
      scope :for_medium, -> (medium) { where(medium: medium) }

      validates :medium, presence: true
      validates :medium, inclusion: { in: Work.valid_media }
    end

    def display_medium
      return unless medium

      medium.constantize.display_medium
    end
  end

  #############################################################################
  # CONCERNING: Name
  #############################################################################

  concerning :Name do
    included do
      validates :name, presence: true
      validates :name, uniqueness: { scope: [:medium] }
    end

    def display_name(full: false)
      full ? [display_medium, name].join(": ") : name
    end
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :for_list,   -> { }
  scope :for_show,   -> { includes(:contributions, :works) }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :contributions, dependent: :nullify

  has_many :works, through: :contributions

  #############################################################################
  # INSTANCE.
  #############################################################################

  def alpha_parts
    [display_medium, name]
  end
end
