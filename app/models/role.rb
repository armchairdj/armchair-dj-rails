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
  # CONCERNING: Alpha.
  #############################################################################

  include Alphabetizable

  def alpha_parts
    [display_medium, name]
  end

  #############################################################################
  # CONCERNING: Medium
  #############################################################################

  validates :medium, presence: true
  validates :medium, inclusion: { in: Work.valid_media }

  scope :for_medium, -> (medium) { where(medium: medium) }

  def display_medium
    return unless medium

    medium.constantize.display_medium
  end

  #############################################################################
  # CONCERNING: Name
  #############################################################################

  concerning :NameAttribute do
    included do
      validates :name, presence: true
      validates :name, uniqueness: { scope: [:medium] }
    end

    def display_name(full: false)
      full ? [display_medium, name].join(": ") : name
    end
  end

  #############################################################################
  # CONCERNING: Contributions
  #############################################################################

  has_many :attributions,  dependent: :destroy
  has_many :contributions, dependent: :destroy

  has_many :works, through: :contributions

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list,   -> { }
  scope :for_show,   -> { includes(:contributions, :works) }
end
