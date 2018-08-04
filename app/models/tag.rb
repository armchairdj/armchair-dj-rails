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

  include Alphabetizable

  def alpha_parts
    [name]
  end

  #############################################################################
  # CONCERNING: Name.
  #############################################################################

  validates :name, presence: true

  #############################################################################
  # CONCERNING: Posts.
  #############################################################################

  has_and_belongs_to_many :posts, -> { distinct }

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list,  -> { }
  scope :for_show,  -> { includes(:posts) }
end
