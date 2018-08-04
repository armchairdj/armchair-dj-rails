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
  # CONCERNING: Authorable.
  #############################################################################

  include Authorable

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  include Alphabetizable

  def alpha_parts
    [title]
  end

  #############################################################################
  # CONCERNING: Title.
  #############################################################################

  validates :title, presence: true

  #############################################################################
  # CONCERNING: Tracks.
  #############################################################################

  has_many :tracks, -> { order(:position) }, inverse_of: :playlist,
    class_name: "Playlist::Track", dependent: :destroy

  validates :tracks, length: { minimum: 2 }

  concerning :NestedTracks do
    MAX_TRACKS_AT_ONCE = 20.freeze

    included do
      accepts_nested_attributes_for(:tracks, allow_destroy: true,
        reject_if: proc { |attrs| attrs["work_id"].blank? }
      )
    end

    def prepare_tracks
      MAX_TRACKS_AT_ONCE.times { self.tracks.build }
    end
  end

  #############################################################################
  # CONCERNING: Works.
  #############################################################################

  has_many :works, through: :tracks

  has_many :makers,       -> { distinct }, through: :works
  has_many :contributors, -> { distinct }, through: :works

  def creators
    Creator.where(id: creator_ids)
  end

  def creator_ids
    works.map(&:creator_ids).flatten.uniq
  end

  #############################################################################
  # CONCERNING: Posts.
  #############################################################################

  has_many :mixtapes, dependent: :nullify

  has_many :reviews, through: :works

  def posts
    Post.where(id: post_ids)
  end

  def post_ids
    reviews.ids + mixtapes.ids
  end

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list,  -> { includes(:author).references(:author) }
  scope :for_show,  -> { includes(:author, :tracks, :works) }
end
