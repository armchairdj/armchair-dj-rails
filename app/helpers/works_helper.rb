module WorksHelper
  def link_to_work(work, full: true, admin: false)
    return unless work && work.persisted?

    text        = full ? work.title_with_creator : work.title
    url_options = admin ? admin_work_path(work) : work

    link_to(text, url_options)
  end

  def links_to_creators_for_work(work, separator: " & ", admin: false)
    return unless work && work.persisted?

    work.creators.map {
      |a| link_to a.name, (admin ? admin_creator_path(a) : a)
    }.join(separator).html_safe
  end
end
