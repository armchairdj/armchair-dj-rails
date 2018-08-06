# == Schema Information
#
# Table name: aspects
#
#  id         :bigint(8)        not null, primary key
#  alpha      :string
#  facet      :integer          not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_aspects_on_alpha  (alpha)
#  index_aspects_on_facet  (facet)
#

class Aspect < ApplicationRecord

  #############################################################################
  # CONCERNING: Alpha.
  #############################################################################

  include Alphabetizable

  def alpha_parts
    [human_facet, name]
  end

  #############################################################################
  # CONCERNING: Facet.
  #############################################################################

  scope :for_facet, -> (*facets) { where(facet: facets.flatten.compact) }

  validates :facet, presence: true

  enum facet: {
    album_format:         0,
    song_type:            1,
    music_label:          2,
    musical_genre:        3,
    musical_mood:         4,

    audio_show_format:  100,
    radio_network:      101,
    podcast_network:    102,

    narrative_genre:    200,
    hollywood_studio:   201,
    tv_network:         202,

    publisher:          301,
    publication_type:   302,

    tech_platform:      401,
    tech_company:       402,
    device_type:        403,

    product_type:       501,
    manufacturer:       502,

    game_mechanic:      601,
    game_studio:        602,
  }

  enumable_attributes :facet

  #############################################################################
  # CONCERNING: Name.
  #############################################################################

  validates :name, presence: true
  validates :name, uniqueness: { scope: [:facet] }

  def display_name(connector: ": ")
    [human_facet, name].compact.join(connector)
  end

  #############################################################################
  # CONCERNING: Works.
  #############################################################################

  has_and_belongs_to_many :works, -> { distinct }

  has_many :playlists,    -> { distinct }, through: :works
  has_many :makers,       -> { distinct }, through: :works
  has_many :contributors, -> { distinct }, through: :works

  #############################################################################
  # CONCERNING: Posts.
  #############################################################################

  has_many :mixtapes, through: :works
  has_many :reviews,  through: :works

  def posts
    Post.where(id: post_ids)
  end

  def post_ids
    reviews.ids + mixtapes.ids
  end

  #############################################################################
  # CONCERNING: Ginsu.
  #############################################################################

  scope :for_list,  -> { }
  scope :for_show,  -> { includes(:works, :makers, :contributors, :playlists, :mixtapes, :reviews) }
end
