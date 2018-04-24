module AdminHelper

  #############################################################################
  # FORMS.
  #############################################################################

  def admin_submit_button(f)
    f.button :submit, f.object.new_record? ? "Create" : "Update"
  end

  #############################################################################
  # FORMATTING.
  #############################################################################

  def admin_date(date)
    return unless date

    time_tag date, date.strftime("%m/%d/%Y %I:%M%p")
  end

  #############################################################################
  # LINKS.
  #############################################################################

  def admin_create_link(model)
    title = "create #{model.model_name.singular}"
    svg   = semantic_svg_image("open_iconic/plus.svg", title: title, desc: "create icon")
    path  = new_polymorphic_path([:admin, model])

    link_to(svg, path, title: title, class: "admin create")
  end

  def admin_destroy_link(instance)
    title = "destroy #{instance.model_name.singular}"
    svg   = semantic_svg_image("open_iconic/trash.svg", title: title, desc: "trash icon")
    path  = polymorphic_path([:admin, instance])

    link_to(svg, path, title: title, class: "admin destroy", method: :delete, "data-confirm": "Are you sure?")
  end

  def admin_list_link(model)
    title = "back to #{model.model_name.plural} list"
    svg   = semantic_svg_image("open_iconic/list.svg", title: title, desc: "list icon")
    path  = polymorphic_path([:admin, model])

    link_to(svg, path, title: title, class: "admin list")
  end

  def admin_public_creator_link(creator)
    return unless creator.viewable?

    admin_public_link(creator)
  end

  def admin_public_post_link(post)
    return unless post.published?

    admin_public_link(post, post_permalink_path(slug: post.slug))
  end

  def admin_public_work_link(work)
    return unless work.viewable?

    admin_public_link(work)
  end

  def admin_public_link(instance, path = nil)
    path ||= polymorphic_path(instance)

    title = "view #{instance.model_name.singular} on site"
    svg   = semantic_svg_image("open_iconic/link-intact.svg", title: title, desc: "public view icon")

    link_to(svg, path, title: title, class: "admin public-view", target: "_blank")
  end

  def admin_update_link(instance)
    title = "update #{instance.model_name.singular}"
    svg   = semantic_svg_image("open_iconic/pencil.svg", title: title, desc: "update icon")
    path  = edit_polymorphic_path([:admin, instance])

    link_to(svg, path, title: title, class: "admin edit")
  end

  def admin_view_link(instance)
    title = "view #{instance.model_name.singular}"
    svg   = semantic_svg_image("open_iconic/eye.svg", title: title, desc: "view icon")
    path  = polymorphic_path([:admin, instance])

    link_to(svg, path, title: title, class: "admin view")
  end
end
