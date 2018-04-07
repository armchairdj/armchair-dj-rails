module WorksHelper
  def link_to_work(work)
    return unless work.persisted?

    link_to(work.title, work)
  end

  def links_to_creators_for_work(work, separator: " & ")
    return unless work.persisted?

    work.creators.map { |a| link_to(a.name, a) }.join(separator).html_safe
  end
end
