module ModuleHelper
  def adj_module(content = nil, **opts, &block)
    content = content || capture(&block)

    tag  = opts.delete(:tag) || :section
    opts = combine_attrs(opts, class: "adj-module")

    content_tag(tag, content, **opts)
  end

  def admin_section(content = nil, headline: nil, subhead: nil, **opts, &block)
    content = content || capture(&block)

    return if content.blank?

    attrs = combine_attrs(opts, class: "admin-section")

    if header = section_header(headline, subhead)
      content = (header + content).html_safe
    end

    content_tag(:section, content, **attrs)
  end

  def section_header(headline = nil, subhead = nil)
    headlines = []
    headlines << content_tag(:h4, headline) unless headline.blank?
    headlines << content_tag(:h6, subhead ) unless subhead.blank?

    return unless headlines.any?

    content_tag(:header, headlines.join.html_safe)
  end
end
