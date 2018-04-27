class Contribution < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  ROLE_GROUPINGS = I18n.t("activerecord.attributes.contribution.role_groupings").freeze

  #############################################################################
  # CONCERNS.
  #############################################################################

  #############################################################################
  # CLASS.
  #############################################################################

  def self.grouped_role_options
    roles = Contribution.human_roles_with_keys
    roles = roles.group_by { |arr| arr.last / 100 }
    roles = roles.reduce([]) do |memo, (key, val)|
      memo << [
        ROLE_GROUPINGS[key],
        val.map { |o| [ o[0], o[1], { "data-work-grouping" => o[2] == 0 ? nil : key } ] }
      ]
      memo
    end
  end

  #############################################################################
  # SCOPES.
  #############################################################################

  scope      :primary, -> { where(    role: roles["creator"]) }
  scope    :secondary, -> { where.not(role: roles["creator"]) }

  scope :alphabetical, -> { }

  scope :viewable,     -> { includes(:work).where.not(works: { viewable_post_count: 0 }) }

  scope     :for_site, -> { secondary.viewable.order("works.title") }
  scope    :for_admin, -> { secondary }

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  belongs_to :work,    required: true
  belongs_to :creator, required: true

  #############################################################################
  # ATTRIBUTES.
  #############################################################################

  accepts_nested_attributes_for :creator,
    allow_destroy: true,
    reject_if:     :reject_blank_creator

  enum role: {
    creator:                        0,

    # Music

    musical_artist:               100,
    musical_featured_artist:      101,

    songwriter:                   110,
    lyricist:                     111,
    composer:                     112,

    music_producer:               120,
    music_executive_producer:     121,
    music_co_producer:            122,

    music_engineer:               130,

    singer:                       140,
    backing_vocalist:             141,

    rapper:                       145,

    musician:                     150,

    remixer:                      160,

    # Movies

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

    music_supervisor:             270,
    score_composer:               271,
    sound_editor:                 272,
    sound_effects:                273,

    # Print

    author:                       300,
    illustrator:                  301,
    
    editor:                       310,

    imprint:                      320,
    publisher:                    321,

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
  # INSTANCE.
  #############################################################################

private

  def reject_blank_creator(creator_attributes)
    creator_attributes["name"].blank?
  end
end
