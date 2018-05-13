module TagsHelper
  def link_to_tag(tag, admin: false, full: false)
    return unless tag.persisted?

    text        = full ? tag.display_name : tag.name
    url_options = admin ? admin_tag_path(tag) : tag

    link_to(text, url_options)
  end
end
