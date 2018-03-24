require "administrate/base_dashboard"

class ArtistDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id:                  Field::Number,
    name:                Field::String,
    created_at:          Field::DateTime,
    updated_at:          Field::DateTime,
    album_contributions: Field::HasMany,
    albums:              Field::HasMany,
    song_contributions:  Field::HasMany,
    songs:               Field::HasMany,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :album_contributions,
    :song_contributions,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :created_at,
    :updated_at,
    :albums,
    :songs,
  ].freeze

  FORM_ATTRIBUTES = [
    :name,
    :album_contributions,
    :song_contributions,
  ].freeze

  def display_resource(artist)
    artist.name.present? ? artist.name : "New Artist"
  end
end
