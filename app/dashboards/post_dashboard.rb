require "administrate/base_dashboard"

class PostDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    postable:     Field::Polymorphic,
    id:           Field::Number,
    title:        Field::String,
    body:         Field::Text,
    published_at: Field::DateTime,
    created_at:   Field::DateTime,
    updated_at:   Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :postable,
    :id,
    :title,
    :body,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :postable,
    :id,
    :title,
    :body,
    :published_at,
    :created_at,
    :updated_at,
  ].freeze

  FORM_ATTRIBUTES = [
    :postable,
    :title,
    :body,
    :published_at,
  ].freeze

  def display_resource(post)
    "Post ##{post.id}"
  end
end
