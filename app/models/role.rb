# frozen_string_literal: true

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
  concerning :Alphabetization do
    included do
      include Alphabetizable
    end

    def alpha_parts
      [display_medium, name]
    end
  end

  concerning :AttributionAssociations do
    included do
      with_options dependent: :destroy do
        has_many :attributions
        has_many :contributions
      end

      has_many :works, through: :contributions
    end
  end

  concerning :GinsuIntegration do
    included do
      scope :for_list, -> {}
      scope :for_show, -> { includes(:contributions, :works) }
    end
  end

  concerning :MediumAssociation do
    included do
      validates :medium, presence: true
      validates :medium, inclusion: { in: Work.valid_media }

      scope :for_medium, ->(medium) { where(medium: medium) }
    end

    def display_medium
      return unless medium

      medium.constantize.display_medium
    end
  end

  concerning :NameAttribute do
    included do
      validates :name, presence: true
      validates :name, uniqueness: { scope: [:medium] }
    end

    def display_name(full: false)
      full ? [display_medium, name].join(": ") : name
    end
  end
end
