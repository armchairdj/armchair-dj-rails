class Aspect < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS.
  #############################################################################

  include Displayable

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope     :eager, -> { includes(:works, :creators, :contributors, :reviews, :mixtapes) }
  scope :for_admin, -> { eager }
  scope  :for_site, -> { eager.viewable.alpha }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_and_belongs_to_many :works

  has_many :creators,     -> { distinct }, through: :works
  has_many :contributors, -> { distinct }, through: :works

  has_many :reviews,  through: :works
  has_many :mixtapes, through: :works

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  enum characteristic: {
    album_type:           0,
    song_type:            1,
    music_label:          2,
    musical_genre:        3,

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

  enumable_attributes :characteristic

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :characteristic, presence: true

  validates :name, presence: true
  validates :name, uniqueness: { scope: [:characteristic] }

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  def display_name(connector: ": ")
    [characteristic, name].compact.join(connector)
  end

  def sluggable_parts
    [characteristic, name]
  end

  def alpha_parts
    [characteristic, name]
  end
end
