module ModuleHelper
  def admin_section(headline = nil, subhead = nil, **opts, &block)
    content = capture(&block)

    return if content.blank?

    header    = section_header(headline, subhead)
    section   = (header + content).html_safe
    attrs     = combine_attrs(opts, class: "admin-section")

    content_tag(:section, section, **attrs)
  end

  def section_header(headline = nil, subhead = nil)
    headlines = []
    headlines << content_tag(:h4, headline) unless headline.blank?
    headlines << content_tag(:h6, subhead ) unless subhead.blank?

    content_tag_unless_empty(:header, headlines.join.html_safe)
  end
end
