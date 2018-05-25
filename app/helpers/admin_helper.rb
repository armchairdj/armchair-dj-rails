# frozen_string_literal: true

module AdminHelper

  #############################################################################
  # FORMS.
  #############################################################################

  def admin_submit_button(f)
    name = f.object.new_record? ? "Create" : "Update"

    f.button :button, name, type: :submit
  end

  #############################################################################
  # FORMATTING.
  #############################################################################

  def admin_date(date, **opts)
    return unless date

    time_tag(date, date.strftime("%m/%d/%Y at %I:%M%p"), **opts)
  end

  def total_count_for(association)
    pluralize(association.total_count, "Total Record")
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

  #############################################################################
  # PUBLIC LINKS.
  #############################################################################

  def admin_public_category_link(category)
    return unless category.viewable?

    admin_public_link(category)
  end

  def admin_public_creator_link(creator)
    return unless creator.viewable?

    admin_public_link(creator)
  end

  def admin_public_medium_link(medium)
    return unless medium.viewable?

    admin_public_link(medium)
  end

  def admin_public_post_link(post)
    return unless post.published?

    admin_public_link(post, post_permalink_path(slug: post.slug))
  end

  def admin_public_tag_link(tag)
    return unless tag.viewable?

    admin_public_link(tag)
  end

  def admin_public_user_link(user)
    return unless user.viewable?

    admin_public_link(user, user_profile_path(username: user.username))
  end

  def admin_public_work_link(work)
    return unless work.viewable?

    admin_public_link(work)
  end

  #############################################################################
  # COLUMN HEADERS.
  #############################################################################

  def admin_column_icon(icon, title, desc)
    svg_icon(icon, title: title, desc: desc, wrapper_class: "admin-column-header")
  end

  def actions_th
    content_tag(:th, "Actions", class: "actions")
  end

  def vpc_th(model, key)
    icon = admin_column_icon("lock-unlocked", "Public Post Count", "unlocked icon")

    sortable_th(model, key, class: "icon", text: icon)
  end

  def nvpc_th(model, key)
    icon = admin_column_icon("lock-locked", "Draft Post Count", "locked icon")

    sortable_th(model, key, class: "icon", text: icon)
  end

  def sortable_th(model, key, **opts)
    sort = model.admin_sorts[key]
    text = opts.delete(:text) || key
    link = link_to(content_tag(:span, text), th_link_url_params(sort), class: th_link_classes(sort))

    content_tag(:th, link, opts)
  end

  def th_link_classes(sort)
    return nil unless equivalent_sort_clauses?(@sort, sort)

    "active #{descending_sort_clause?(@sort) ? 'desc' : 'asc'}"
  end

  def equivalent_sort_clauses?(first, last)
    base_sort_clause(first) == base_sort_clause(last)
  end

  def base_sort_clause(sort_clause)
    sort_clause.gsub(/ (ASC|DESC)/, "")
  end

  def descending_sort_clause?(sort_clause)
    sort_clause.split(/, ?/).first.match(/DESC/)
  end

  def th_link_url_params(sort)
    url_params         = {}
    url_params[:scope] = @scope
    url_params[:sort]  = sort == @sort ? reverse_sort : sort
    url_params
  end

  def reverse_sort
    parts = @sort.split(/, ?/)

    if parts[0].match(/DESC/)
      parts[0] = parts[0].gsub("DESC", "ASC")
    elsif parts[0].match(/ASC/)
      parts[0] = parts[0].gsub("ASC", "DESC")
    else
      parts[0] = "#{parts[0]} DESC"
    end

    parts.join(", ")
  end

  #############################################################################
  # COLUMN CELLS.
  #############################################################################

  def vpc_cell(instance)
    content_tag(:td, instance.viewable_post_count, class: "icon")
  end

  def nvpc_cell(instance)
    content_tag(:td, instance.non_viewable_post_count, class: "icon")
  end
end
