# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_tags_on_alpha  (alpha)
#

class Tag < ApplicationRecord
  #############################################################################
  # CONCERNING: Name.
  #############################################################################

  concerning :NameAttribute do
    included do
      validates :name, presence: true
    end
  end

  #############################################################################
  # CONCERNING: Posts.
  #############################################################################

  concerning :PostAssociations do
    included do
      has_and_belongs_to_many :posts, -> { distinct }
    end
  end

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list,  -> {}
  scope :for_show,  -> { includes(:posts) }

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  include Alphabetizable

  concerning :Alphabetization do
    def alpha_parts
      [name]
    end
  end
end
