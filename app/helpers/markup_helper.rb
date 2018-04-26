module MarkupHelper
  def combine_attrs(first, last)
    klasses = combine_classes(first.delete(:class), last.delete(:class))

    first.merge(last).merge(class: klasses)
  end

  def combine_classes(*classes)
    classes.flatten.compact.join(" ").squish
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
