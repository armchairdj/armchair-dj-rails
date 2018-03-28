require "administrate/base_dashboard"

class WorkDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    posts:              Field::HasMany,
    id:                 Field::Number,
    title:              Field::String,
    work_contributions: Field::HasMany,
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
    :work_contributions
  ].freeze

  def display_resource(work)
    work.title.present? ? work.title : "New Work"
  end
end
