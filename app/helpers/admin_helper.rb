# frozen_string_literal: true

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

  def admin_date(date, **opts)
    return unless date

    time_tag(date, date.strftime("%m/%d/%Y at %I:%M%p"), **opts)
  end

  #############################################################################
  # LINKS.
  #############################################################################

  def admin_link_to(icon, path, title, desc, **opts)
    svg = semantic_svg_image("open_iconic/#{icon}.svg", title: title, desc: desc)

    link_to(svg, path, title: title, **opts)
  end

  def admin_create_link(model)
    path  = new_polymorphic_path([:admin, model])
    title = "create #{model.model_name.singular}"
    desc  = "create icon"
    icon  = "plus"

    admin_link_to(icon, path, title, desc, class: "admin create")
  end

  def admin_destroy_link(instance)
    path  = polymorphic_path([:admin, instance])
    title = "destroy #{instance.model_name.singular}"
    desc  = "trash icon"
    icon  = "trash"

    admin_link_to(icon, path, title, desc, class: "admin destroy", method: :delete, "data-confirm": "Are you sure?")
  end

  def admin_list_link(model)
    path  = polymorphic_path([:admin, model])
    title = "back to #{model.model_name.plural} list"
    desc  = "list icon"
    icon  = "list"

    admin_link_to(icon, path, title, desc, class: "admin list")
  end

  def admin_public_link(instance, path = nil)
    path ||= polymorphic_path(instance)

    title = "view #{instance.model_name.singular} on site"
    desc  = "public view icon"
    icon  = "link-intact"

    admin_link_to(icon, path, title, desc, class: "admin public-view", target: "_blank")
  end

  def admin_update_link(instance)
    path  = edit_polymorphic_path([:admin, instance])
    title = "update #{instance.model_name.singular}"
    desc  = "update icon"
    icon  = "pencil"

    admin_link_to(icon, path, title, desc, class: "admin edit")
  end

  def admin_view_link(instance)
    path  = polymorphic_path([:admin, instance])
    title = "view #{instance.model_name.singular}"
    desc  = "view icon"
    icon  = "eye"

    admin_link_to(icon, path, title, desc, class: "admin view")
  end

  def admin_public_post_link(post)
    return unless post.published?

    admin_public_link(post, post_permalink_path(slug: post.slug))
  end

  def admin_public_creator_link(creator)
    return unless creator.viewable?

    admin_public_link(creator)
  end

  def admin_public_work_link(work)
    return unless work.viewable?

    admin_public_link(work)
  end

  def admin_public_medium_link(medium)
    return unless medium.viewable?

    admin_public_link(medium)
  end

  def admin_public_genre_link(genre)
    return unless genre.viewable?

    admin_public_link(genre)
  end

  #############################################################################
  # COLUMN HEADERS.
  #############################################################################

  def admin_column_header(icon, title, desc)
    svg_icon(icon, title: title, desc: desc, wrapper_class: "admin-column-header")
  end

  def post_count_column_header
    admin_column_header("lock-unlocked", "Public Posts", "unlocked icon")
  end

  def draft_count_column_header
    admin_column_header("lock-locked", "Draft Posts", "locked icon")
  end

  def work_count_column_header
    admin_column_header("person", "Viewable Works", "person icon")
  end

  def contribution_count_column_header
    admin_column_header("people", "Viewable Contributions", "people icon")
  end
end
