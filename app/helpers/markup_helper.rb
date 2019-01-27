# frozen_string_literal: true

module MarkupHelper
  def blockquote(text = nil, author:, cite: nil, &block)
    raise ArgumentError if text.nil? && !block_given?

    quote = text || capture(&block)
    html  = content_tag(:blockquote, quote) + caption(author, cite)

    content_tag(:figure, html.html_safe, class: "quote")
  end

  def caption(author, cite = nil)
    caption = [content_tag(:strong, author)]
    caption << content_tag(:cite, cite) unless cite.nil?

    content_tag(:figcaption, caption.join().html_safe)
  end

  def combine_attrs(first, last)
    klasses = combine_classes(first.delete(:class), last.delete(:class))

    first.merge(last).merge(class: klasses)
  end

  def combine_classes(*classes)
    classes.flatten.compact.map(&:squish).compact.uniq.join(" ").squish
  end

  def content_for_unless_empty(key, wrapper: nil, **options)
    return unless content_for?(key.to_sym)

    content = content_for(key.to_sym)

    return content if wrapper.nil?

    content_tag(wrapper.to_sym, content, options)
  end

  def content_tag_unless_empty(tag, content, **opts)
    return if content.blank?

    content_tag(tag, content, **opts)
  end

  def date_tag(date, **opts)
    return unless date

    time_tag(date, l(date), **opts)
  end

  def paragraphs(str, extra = nil)
    return if str.blank?

    ps = str.split(/[\r\n]+ *[\r\n]+/).map { |p| p.squish }.delete_if(&:blank?)

    ps[ps.length - 1] = "#{ps.last} #{extra}".html_safe unless extra.nil?

    ps.map { |p| content_tag(:p, p) }.join("\n").html_safe
  end

  def smart_truncate(str, length: nil)
    return str.html_safe if length.nil?

    truncate(str.html_safe, length: length, omission: "…", separator: " ")
  end
end
