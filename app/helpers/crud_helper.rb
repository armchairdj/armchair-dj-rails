module CrudHelper
  def crud_create_link(model)
    svg   = semantic_svg_image("open_iconic/plus.svg", "plus sign", "addition icon")
    path  = new_polymorphic_path(model)
    title = "new #{model.model_name.singular}"

    link_to(svg, path, title: title, class: "crud create")
  end

  def crud_destroy_link(instance)
    svg   = semantic_svg_image("open_iconic/x.svg", "x", "delete icon")
    path  = polymorphic_path(instance)
    title = "destroy #{instance.model_name.singular}"

    link_to(svg, path, title: title, class: "crud destroy",
      method: :delete, "data-confirm": "Are you sure?"
    )
  end

  def crud_view_link(instance)
    svg   = semantic_svg_image("open_iconic/eye.svg", "eyeball", "eyeball icon")
    path  = polymorphic_path(instance)
    title = "view #{instance.model_name.singular}"

    link_to(svg, path, title: title, class: "crud show")
  end

  def crud_update_link(instance)
    svg   = semantic_svg_image("open_iconic/pencil.svg", "pencil", "pencil icon")
    path  = edit_polymorphic_path(instance)
    title = "edit #{instance.model_name.singular}"

    link_to(svg, path, title: title, class: "crud edit")
  end
end
