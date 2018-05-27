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

  def admin_public_link_for(instance)
    case instance.model_name
    when "Creator"
      admin_public_creator_link(instance)
    when "Medium"
      admin_public_medium_link(instance)
    when "Post"
      admin_public_post_link(instance)
    when "Tag"
      admin_public_tag_link(instance)
    when "User"
      admin_public_user_link(instance)
    when "Work"
      admin_public_work_link(instance)
    end
  end

  def admin_public_link(instance, path = nil)
    path ||= polymorphic_path(instance)

    title = "view #{instance.model_name.singular} on site"
    desc  = "public view icon"
    icon  = "link-intact"

    admin_link_to(icon, path, title, desc, class: "admin public-view")
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
  # ACTION LINKS.
  #############################################################################

  # TODO pundit
  def admin_header(model_class, action, **opts)
    links  = admin_header_links(model_class, action, opts.delete(:instance))
    pieces = opts.slice(:h4, :h1, :h2, :h3).map { |k, v| content_tag(k, v) }
    pieces << content_tag(:div, links, class: "actions")

    content_tag(:header, pieces.join.html_safe, class: "admin")
  end

  def admin_header_links(model_class, action, instance = nil)
    links = case action
    when :index
      [
        admin_create_link(    model_class)
      ]
    when :new
      [
        admin_list_link(      model_class)
      ]
    when :edit
      [
        admin_public_link_for(   instance),
        admin_view_link(         instance),
        admin_destroy_link(      instance),
        admin_list_link(      model_class),
      ]
    when :show
      [
        admin_public_link_for(   instance),
        admin_update_link(       instance),
        admin_destroy_link(      instance),
        admin_list_link(      model_class),
      ]
    end

    links.join.html_safe
  end

  # TODO pundit
  def admin_actions(instance)
    links = [
      admin_public_link_for(instance),
      admin_view_link(      instance),
      admin_update_link(    instance),
      admin_destroy_link(   instance)
    ].compact.join.html_safe

    content_tag(:td, links, class: "actions")
  end

  #############################################################################
  # INDEX TABS.
  #############################################################################

  def admin_index_tabs(scopes)
    tabs = scopes.map do |scope_name, props|
      if props[:active?]
        content_tag :li, content_tag(:span, scope_name, class: "tab-active")
      else
        content_tag :li, link_to(scope_name, props[:url])
      end
    end

    content_tag(:ul, tabs.join.html_safe, class: "tabs")
  end

  #############################################################################
  # TABLE ICONS.
  #############################################################################

  def admin_column_icon(icon, title, desc)
    svg_icon(icon, title: title, desc: desc, wrapper_class: "admin-column-header")
  end

  def vpc_icon
    admin_column_icon("lock-unlocked", "Public Post Count", "unlocked icon")
  end

  def nvpc_icon
    admin_column_icon("lock-locked", "Draft Post Count", "locked icon")
  end

  def post_status_icon
    admin_column_icon("eye", "Post Status", "eye icon")
  end

  #############################################################################
  # TABLES.
  #############################################################################

  def actions_th
    content_tag(:th, "Actions", class: "actions")
  end

  def sortable_th(sorts, name, **opts)
    props   = sorts[name]
    text    = content_tag(:span, opts.delete(:text) || name)
    classes = props[:active?] ? "active #{props[:desc?] ? 'desc' : 'asc'}" : nil

    content_tag(:th, link_to(text, props[:url], class: classes), opts)
  end
end
