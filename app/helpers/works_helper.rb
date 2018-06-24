# frozen_string_literal: true

module WorksHelper
  def link_to_work(work, full: true, **opts)
    text = work.display_title(full: full)
    url  = admin_work_path(work)

    link_to(text, url, **opts)
  end
end
