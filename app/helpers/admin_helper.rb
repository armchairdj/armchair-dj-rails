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

  def admin_post_status(post)
    return post.human_status if post.draft?

    date = date_tag(post.publish_date, pubdate: "pubdate")
    prep = post.scheduled? ? "for" : "on"

    "#{post.human_status} #{prep} #{date}".html_safe
  end

  def total_count_for(association)
    pluralize(association.total_count, "Total Record")
  end

  #############################################################################
  # POLYMORPHIC WRAPPERS.
  #############################################################################

  def admin_link_for(instance, full_url: false)
    opts = [:admin, instance]

    full_url ? polymorphic_url(opts) : polymorphic_path(opts)
  end

  def admin_link_for_edit(instance, full_url: false)
    opts = [:admin, instance]

    full_url ? edit_polymorphic_url(opts) : edit_polymorphic_path(opts)
  end

  def admin_link_for_new(model, full_url: false)
    opts = [:admin, model]

    full_url ? new_polymorphic_url(opts) : new_polymorphic_path(opts)
  end

  def admin_link_for_list(model, full_url: false)
    opts = [:admin, model]

    full_url ? polymorphic_url(opts) : polymorphic_path(opts)
  end

  #############################################################################
  # LINKS.
  #############################################################################

  def admin_link_to(icon, path, title, desc, **opts)
    svg = semantic_svg_image("open_iconic/#{icon}.svg", title: title, desc: desc)

    link_to(svg, path, title: title, **opts)
  end

  def admin_list_link(model)
    path  = admin_link_for_list(model)
    title = "back to #{model.model_name.plural} list"
    desc  = "list icon"
    icon  = "list"

    admin_link_to(icon, path, title, desc, class: "admin list")
  end

  def admin_view_link(instance)
    path  = admin_link_for(instance)
    title = "view #{instance.model_name.singular}"
    desc  = "view icon"
    icon  = "eye"

    admin_link_to(icon, path, title, desc, class: "admin view")
  end

  def admin_create_link(model)
    path  = admin_link_for_new(model)
    title = "create #{model.model_name.singular}"
    desc  = "create icon"
    icon  = "plus"

    admin_link_to(icon, path, title, desc, class: "admin create")
  end

  def admin_update_link(instance)
    path  = admin_link_for_edit(instance)
    title = "update #{instance.model_name.singular}"
    desc  = "update icon"
    icon  = "pencil"

    admin_link_to(icon, path, title, desc, class: "admin edit")
  end

  def admin_destroy_link(instance)
    klass = instance.is_a?(Work) ? Work : instance.class

    return unless Pundit.policy!(current_user, [:admin, klass]).destroy?

    path  = admin_link_for(instance)
    title = "destroy #{instance.model_name.singular}"
    desc  = "trash icon"
    icon  = "trash"

    admin_link_to(icon, path, title, desc, class: "admin destroy", method: :delete, "data-confirm": "Are you sure?")
  end

  def admin_public_link(instance)
    path = nil
    path = url_for_user(instance) if instance.is_a?(User)
    path = url_for_post(instance) if instance.is_a?(Post)

    return unless path

    title = "view #{instance.model_name.singular} on site"
    desc  = "public view icon"
    icon  = "link-intact"

    admin_link_to(icon, path, title, desc, class: "admin public-view")
  end

  #############################################################################
  # ACTION LINKS.
  #############################################################################

  def admin_nav_links
    links = [
      link_to("Articles",    admin_articles_path      ),
      link_to("Reviews",     admin_reviews_path       ),
      link_to("Mixtapes",    admin_mixtapes_path      ),
      link_to("Playlists",   admin_playlists_path     ),
      link_to("Works",       admin_works_path         ),
      link_to("Creators",    admin_creators_path      ),
      link_to("Roles",       admin_roles_path         ),
      link_to("Aspects",     admin_aspects_path       ),
      link_to("Tags",        admin_tags_path          ),
      link_to("Styles",      style_guides_path        ),
      link_to("Log Out",     destroy_user_session_path)
    ]

    if Pundit.policy!(current_user, [:admin, User]).index?
      links.unshift link_to("Users", admin_users_path)
    end

    markup = links.map { |link| content_tag(:li, link) }.compact.join("\n").html_safe

    content_tag(:ul, markup, class: "arrowed")
  end

  def admin_header_links(model_class, action, instance = nil)
    links = case action
    when :index
      [
        admin_create_link(model_class)
      ]
    when :new
      [
        admin_list_link(  model_class)
      ]
    when :edit
      [
        admin_public_link(  instance),
        admin_view_link(    instance),
        admin_destroy_link( instance),
        admin_list_link( model_class),
      ]
    when :show
      [
        admin_public_link(  instance),
        admin_update_link(  instance),
        admin_destroy_link( instance),
        admin_list_link( model_class),
      ]
    end

    links.compact.join.html_safe
  end

  #############################################################################
  # TABLE ICONS.
  #############################################################################

  def admin_column_icon(icon, title, desc)
    svg_icon(icon, title: title, desc: desc, wrapper_class: "admin-column-header")
  end

  def published_status_icon
    admin_column_icon("eye", "Post Status", "eye icon")
  end

  def published_icon
    admin_column_icon("lock-unlocked", "Published", "unlocked icon")
  end

  def unpublished_icon
    admin_column_icon("lock-locked", "Unpublished", "locked icon")
  end

  #############################################################################
  # TABLES.
  #############################################################################

  def sortable_link(sorts, name, text: nil)
    text    = text || content_tag(:span, name)
    props   = sorts[name]
    classes = props[:active?] ? "active #{props[:desc?] ? 'desc' : 'asc'}" : nil

    link_to(text, props[:url], class: classes)
  end
end
