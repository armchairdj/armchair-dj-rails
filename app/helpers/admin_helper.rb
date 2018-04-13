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

    date.strftime("%m/%d/%Y %I:%M%p")
  end

  #############################################################################
  # LINKS.
  #############################################################################

  def admin_create_link(model)
    svg   = semantic_svg_image("open_iconic/plus.svg", title: "plus sign", desc: "create icon")
    path  = new_polymorphic_path([:admin, model])
    title = "new #{model.model_name.singular}"

    link_to(svg, path, title: title, class: "admin create")
  end

  def admin_destroy_link(instance)
    svg   = semantic_svg_image("open_iconic/x.svg", title: "x", desc: "destroy icon")
    path  = polymorphic_path([:admin, instance])
    title = "destroy #{instance.model_name.singular}"

    link_to(svg, path, title: title, class: "admin destroy",
      method: :delete, "data-confirm": "Are you sure?"
    )
  end

  def admin_view_link(instance)
    svg   = semantic_svg_image("open_iconic/eye.svg", title: "eyeball", desc: "view icon")
    path  ||= polymorphic_path([:admin, instance])
    title = "view #{instance.model_name.singular}"

    link_to(svg, path, title: title, class: "admin view")
  end

  def admin_public_view_link(instance, path = nil)
    path  ||= polymorphic_path(instance)

    svg   = semantic_svg_image("open_iconic/eye.svg", title: "globe", desc: "public view icon")
    title = "view #{instance.model_name.singular} on site"

    link_to(svg, path, title: title, class: "admin public-view")
  end

  def admin_update_link(instance)
    svg   = semantic_svg_image("open_iconic/pencil.svg", title: "pencil", desc: "update icon")
    path  = edit_polymorphic_path([:admin, instance])
    title = "edit #{instance.model_name.singular}"

    link_to(svg, path, title: title, class: "admin edit")
  end
end
