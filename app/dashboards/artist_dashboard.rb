require "administrate/base_dashboard"

class ArtistDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    albums:     Field::HasMany,
    songs:      Field::HasMany,
    id:         Field::Number,
    name:       Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :albums,
    :songs,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :albums,
    :songs,
    :id,
    :name,
    :created_at,
    :updated_at,
  ].freeze

  FORM_ATTRIBUTES = [
    :albums,
    :songs,
    :name,
  ].freeze

  def display_resource(artist)
    "Artist ##{artist.id}"
  end
end
