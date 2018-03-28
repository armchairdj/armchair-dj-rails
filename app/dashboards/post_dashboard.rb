require "administrate/base_dashboard"

class PostDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id:           Field::Number,
    postable:     Field::Polymorphic.with_options(classes: [Work, Work]),
    title:        Field::String,
    body:         Field::Text,
    created_at:   Field::DateTime,
    updated_at:   Field::DateTime,
    published_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :id,
    :postable,
    :title,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :postable,
    :title,
    :body,
    :created_at,
    :updated_at,
    :published_at,
  ].freeze

  FORM_ATTRIBUTES = [
    :postable,
    :title,
    :body,
  ].freeze

  def display_resource(post)
    post.title.present? ? post.title : "New Post"
  end
end
