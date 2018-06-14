# frozen_string_literal: true

module LinkHelper
  def permalink_for(instance, full: false)
    return unless instance.respond_to?(:viewable?) && instance.viewable?

    full ? polymorphic_url(instance) : polymorphic_path(instance)
  end

  def admin_permalink_for(instance, full: false)
    full ? polymorphic_url([:admin, instance]) : polymorphic_path([:admin, instance])
  end

  def admin_edit_permalink_for(instance, full: false)
    full ? edit_polymorphic_url([:admin, instance]) : edit_polymorphic_path([:admin, instance])
  end

  def admin_new_permalink_for(model, full: false)
    full ? new_polymorphic_url([:admin, model]) : new_polymorphic_path([:admin, model])
  end

  def admin_list_permalink_for(model, full: false)
    full ? polymorphic_url([:admin, model]) : polymorphic_path([:admin, model])
  end
end
