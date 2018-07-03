module LinksHelper
  def link_list(links, **opts)
    return if links.empty?

    list = links.map { |link| content_tag(:li, link_to(link.description, link.url)) }

    content_tag(:ul, list.join.html_safe, **opts)
  end
end
