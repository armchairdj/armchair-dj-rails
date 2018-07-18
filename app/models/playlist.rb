# == Schema Information
#
# Table name: playlists
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint(8)
#
# Indexes
#
#  index_playlists_on_alpha  (alpha)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#

class Playlist < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  MAX_PLAYLISTINGS_AT_ONCE = 20.freeze

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Authorable
  include Alphabetizable

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :for_list,  -> { includes(:author).references(:author) }
  scope :for_show,  -> { includes(:author, :playlistings, :works) }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :playlistings, -> { order(:position) }, inverse_of: :playlist, dependent: :destroy

  has_many :works, through: :playlistings

  has_many :makers,       -> { distinct }, through: :works
  has_many :contributors, -> { distinct }, through: :works

  has_many :mixtapes, dependent: :destroy

  has_many :reviews, through: :works

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :playlistings, allow_destroy: true,
    reject_if: proc { |attrs| attrs["work_id"].blank? }

  def prepare_playlistings
    MAX_PLAYLISTINGS_AT_ONCE.times { self.playlistings.build }
  end

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :title, presence: true

  validates :playlistings, length: { minimum: 2 }

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def alpha_parts
    [title]
  end

  def posts
    Post.where(id: post_ids)
  end

  def post_ids
    reviews.ids + mixtapes.ids
  end

  def creators
    Creator.where(id: creator_ids)
  end

  def creator_ids
    works.map(&:creator_ids).flatten.uniq
  end
end
