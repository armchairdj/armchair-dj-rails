# frozen_string_literal: true

module LinkHelper
  def permalink_path_for(instance)
    return unless instance.respond_to?(:viewable?) && instance.viewable?

    if instance.is_a? User
      user_profile_path(username: instance.username)
    else
      send("#{instance.model_name.param_key}_permalink_path", slug: instance.slug)
    end
  end
end
