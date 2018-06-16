# frozen_string_literal: true

module WorksHelper
  def link_to_work(work, full: true, admin: false, **opts)
    return unless admin

    text = work.display_title(full: full)
    url  = admin ? admin_work_path(work) : work_path(work)

    link_to(text, url, **opts)
  end
end
