require "administrate/base_dashboard"

class SongDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    posts:              Field::HasMany,
    id:                 Field::Number,
    title:              Field::String,
    song_contributions: Field::HasMany,
    created_at:         Field::DateTime,
    updated_at:         Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :id,
    :title,
    :posts,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :title,
    :created_at,
    :updated_at,
    :posts,
  ].freeze

  FORM_ATTRIBUTES = [
    :title,
    :song_contributions
  ].freeze

  def display_resource(song)
    song.title.present? ? song.title : "New Song"
  end
end
