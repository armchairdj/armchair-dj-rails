module CrudHelper
  def crud_create_link(model)
    svg = semantic_svg_image("open_iconic/plus.svg", "plus sign", "addition icon")

    link_to svg, new_polymorphic_path(model),
      title: "edit #{model.model_name.singular}",
      class: "crud create"
  end

  def crud_show_link(url_options)
    instance = url_options.is_a?(Array) ? url_options.last : url_options
    svg      = semantic_svg_image("open_iconic/eye.svg", "eyeball", "eyeball icon")

    link_to svg, polymorphic_path(url_options),
      title: "view #{instance.model_name.singular}",
      class: "crud show"
  end

  def crud_update_link(url_options)
    instance = url_options.is_a?(Array) ? url_options.last : url_options
    svg      = semantic_svg_image("open_iconic/pencil.svg", "pencil", "pencil icon")

    link_to svg, edit_polymorphic_path(url_options),
      title: "edit #{instance.model_name.singular}",
      class: "crud edit"
  end

  def crud_destroy_link(url_options)
    instance = url_options.is_a?(Array) ? url_options.last : url_options
    svg      = semantic_svg_image("open_iconic/x.svg", "x", "delete icon")

    link_to svg, polymorphic_path(url_options),
      method: :delete, "data-confirm": "Are you sure?",
      title: "destroy #{instance.model_name.singular}",
      class: "crud destroy"
  end
end
