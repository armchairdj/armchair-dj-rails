require "administrate/base_dashboard"

class CreatorDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id:                  Field::Number,
    name:                Field::String,
    created_at:          Field::DateTime,
    updated_at:          Field::DateTime,
    work_contributions: Field::HasMany,
    works:              Field::HasMany,
    work_contributions:  Field::HasMany,
    works:               Field::HasMany,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :work_contributions,
    :work_contributions,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :created_at,
    :updated_at,
    :works,
    :works,
  ].freeze

  FORM_ATTRIBUTES = [
    :name,
    :work_contributions,
    :work_contributions,
  ].freeze

  def display_resource(creator)
    creator.name.present? ? creator.name : "New Creator"
  end
end
