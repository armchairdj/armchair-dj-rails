class Contribution < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS & PLUGINS.
  #############################################################################

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :work,    required: true
  belongs_to :creator, required: true

  #############################################################################
  # NESTED ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :creator,
    allow_destroy: true,
    reject_if:     :reject_blank_creator

  #############################################################################
  # ENUMS.
  #############################################################################

  enum role: {
    creator:                        0,

    # Music

    musical_artist:               100,
    musical_featured_artist:      101,

    songwriter:                   110,
    lyricist:                     111,

    music_producer:               120,
    music_executive_producer:     121,
    music_co_producer:            122,

    music_engineer:               130,

    singer:                       140,

    musician:                     150,

    # Broadcasting

    director:                     200,

    producer:                     220,
    executive_producer:           221,
    showrunner:                   222,
    co_producer:                  222,

    cinematographer:              230,
    film_editor:                  231,

    screenwriter:                 240,

    radio_host:                   250,
    podcaster:                    260,

    # Print

    author:                       300,
    editor:                       310,

    book_imprint:                 320,
    comics_imprint:               321,
    magazine_publisher:           322,
    newspaper_publisher:          323,

    cartoonist:                   330,
    penciller:                    331,
    inker:                        332,
    colorist:                     333,
    letterer:                     334,

    # Art

    artist:                       400,

    # Tech

    game_platform:                500,
    game_studio:                  510,

    software_platform:            520,
    software_comapny:             521,
    programmer:                   522,

    hardware_company:             550,

    # Product

    brand:                        600,
  }

  enumable_attributes :role

  #############################################################################
  # SCOPES.
  #############################################################################

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :role,    presence: true
  validates :work,    presence: true
  validates :creator, presence: true

  validates :creator_id, uniqueness: { scope: [:work_id, :role] }

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # CLASS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

private

  def reject_blank_creator(creator_attributes)
    creator_attributes["name"].blank?
  end
end
