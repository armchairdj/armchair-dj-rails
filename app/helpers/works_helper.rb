# frozen_string_literal: true

module WorksHelper
  def link_to_work(work, full: true, admin: false)
    return unless work && work.persisted?

    text        = full ? work.full_display_title : work.display_title
    url_options = admin ? admin_work_path(work) : work

    link_to(text, url_options)
  end
end
