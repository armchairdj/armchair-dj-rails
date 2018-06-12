# frozen_string_literal: true

module LinkHelper
  def permalink_for(instance, full: false)
    return unless instance.respond_to?(:viewable?) && instance.viewable?

    full ? polymorphic_url(instance) : polymorphic_path(instance)
  end
end
