require "administrate/base_dashboard"

class AlbumDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    artist:     Field::BelongsTo,
    posts:      Field::HasMany,
    id:         Field::Number,
    title:      Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :id,
    :title,
    :artist,
    :posts,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :artist,
    :posts,
    :id,
    :title,
    :created_at,
    :updated_at,
  ].freeze

  FORM_ATTRIBUTES = [
    :artist,
    :posts,
    :title,
  ].freeze

  def display_resource(album)
    "Album #{album.name}"
  end
end
