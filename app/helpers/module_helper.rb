module ModuleHelper
  def admin_section(headline, subhead = nil, &block)
    content = capture(&block)

    return if content.blank?

    header    = section_header(headline, subhead)
    section   = (header + content).html_safe

    content_tag(:section, section, class: "admin-section")
  end

  def section_header(headline, subhead = nil)
    headlines = [ content_tag(:h4, headline) ]
    headlines << content_tag(:h6, subhead) unless subhead.blank?

    content_tag(:header, headlines.join.html_safe)
  end
end
