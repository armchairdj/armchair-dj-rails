module CreatorsHelper
  def link_to_creator(creator, admin: false)
    return unless creator.persisted?

    text        = creator.name
    url_options = admin ? admin_creator_path(creator) : creator

    link_to(text, url_options)
  end
end
