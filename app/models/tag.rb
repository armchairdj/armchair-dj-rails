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
  # CONCERNING: Alpha.
  #############################################################################

  concerning :Alpha do
    included do
      include Alphabetizable
    end

    def alpha_parts
      [name]
    end
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :for_list,  -> { }
  scope :for_show,  -> { includes(:posts) }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_and_belongs_to_many :posts, -> { distinct }

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence: true
end
