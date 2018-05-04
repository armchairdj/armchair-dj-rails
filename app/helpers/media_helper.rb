# frozen_string_literal: true

module MediaHelper
  def link_to_medium(medium, admin: false)
    return unless medium.persisted?

    text        = medium.name
    url_options = admin ? admin_medium_path(medium) : medium

    link_to(text, url_options)
  end
end
