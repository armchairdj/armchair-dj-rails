module WorksHelper
  def link_to_work(work)
    link_to(work.title, work)
  end

  def links_to_creators_for_work(work)
    work.creators.map { |a| link_to(a.name, a) }.join(" & ").html_safe
  end
end
