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

  def paragraphs(str)
    return if str.blank?

    str.strip.split("\n\n").map { |p| content_tag(:p, p.squish) }.join("\n").html_safe
  end
end
