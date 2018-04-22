module WorksHelper
  def link_to_work(work, full: true)
    return unless work.persisted?

    name = full ? work.title_with_creator : work.title

    link_to(name, work)
  end

  def links_to_creators_for_work(work, separator: " & ")
    return unless work.persisted?

    work.creators.map { |a| link_to(a.name, a) }.join(separator).html_safe
  end
end
