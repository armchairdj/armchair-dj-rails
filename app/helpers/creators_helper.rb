# frozen_string_literal: true

module CreatorsHelper
  def link_to_creator(creator, admin: false, **opts)
    return unless admin

    text = creator.name
    url  = admin ? admin_creator_path(creator) : creator_path(creator)

    link_to(text, url, **opts)
  end
end
