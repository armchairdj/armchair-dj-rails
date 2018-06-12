# frozen_string_literal: true

module LinkHelper
  def permalink_path_for(instance)
    return unless instance.respond_to?(:viewable?) && instance.viewable?

    polymorphic_path(instance)
  end

  def permalink_url_for(instance)
    return unless instance.respond_to?(:viewable?) && instance.viewable?

    polymorphic_url(instance)
  end
end
