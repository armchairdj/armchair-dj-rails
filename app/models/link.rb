# == Schema Information
#
# Table name: links
#
#  id            :bigint(8)        not null, primary key
#  description   :string
#  linkable_type :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  linkable_id   :bigint(8)
#
# Indexes
#
#  index_links_on_linkable_type_and_linkable_id  (linkable_type,linkable_id)
#

class Link < ApplicationRecord

  #############################################################################
  # CONCERNING: Polymorphism.
  #############################################################################

  belongs_to :linkable, polymorphic: true

  #############################################################################
  # CONCERNING: URL.
  #############################################################################

  validates :url, presence: true, urlness: true

  #############################################################################
  # CONCERNING: Description.
  #############################################################################

  validates :description, presence: true
end
