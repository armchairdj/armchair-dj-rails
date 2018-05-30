# frozen_string_literal: true

module WorksHelper
  def link_to_work(instance, full: true, admin: false, **opts)
    return unless admin || instance.viewable?

    text = instance.display_title(full: full)
    url  = admin ? admin_work_path(instance) : work_permalink_path(slug: instance.slug)

    link_to(text, url, **opts)
  end
end
