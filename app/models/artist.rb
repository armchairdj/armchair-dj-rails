class Artist < ApplicationRecord

  #############################################################################
  # CONSTANTS.
  #############################################################################

  #############################################################################
  # CONCERNS & PLUGINS.
  #############################################################################

  #############################################################################
  # ASSOCIATIONS.
  #############################################################################

  has_many :album_contributions
  has_many :albums, -> { where(:album_contributions => {
    role: AlbumContribution.roles["credited_artist"] })
  }, through: :album_contributions

  has_many :song_contributions
  has_many :songs, -> { where(:song_contributions => {
    role: SongContribution.roles["credited_artist"] })
  }, through: :song_contributions

  #############################################################################
  # ENUMS.
  #############################################################################

  #############################################################################
  # SCOPES.
  #############################################################################

  scope :alphabetical, -> { order(:name) }

  #############################################################################
  # VALIDATIONS.
  #############################################################################

  validates :name, presence: true

  #############################################################################
  # HOOKS.
  #############################################################################

  #############################################################################
  # INSTANCE.
  #############################################################################

  #############################################################################
  # CLASS.
  #############################################################################

end
