module MarkupHelper
  def content_for_unless_empty(key, wrapper: nil, **options)
    return unless content_for?(key.to_sym)

    content = content_for(key.to_sym)

    return content if wrapper.nil?

    content_tag(wrapper.to_sym, content, options)
  end
end
