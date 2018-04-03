module MarkupHelper
  def content_for_unless_empty(key)
    return unless content_for?(key.to_sym)

    content_for(key.to_sym)
  end
end