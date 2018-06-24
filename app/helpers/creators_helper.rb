# frozen_string_literal: true

module CreatorsHelper
  def link_to_creator(creator, **opts)
    text = creator.name
    url  = admin_creator_path(creator)

    link_to(text, url, **opts)
  end
end
