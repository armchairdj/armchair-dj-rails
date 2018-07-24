# frozen_string_literal: true

module AdminHelper
  #############################################################################
  # FORMS.
  #############################################################################

  def admin_submit_button(f)
    name = f.object.new_record? ? "Save" : "Save Changes"

    f.button :button, name, type: :submit
  end

  #############################################################################
  # FORMATTING.
  #############################################################################

  def admin_post_status(post)
    if post.published?
      phrase = "Published on"
      date   = post.published_at
    elsif post.scheduled?
      phrase = "Scheduled for"
      date   = post.publish_on
    else
      phrase = "Draft updated on"
      date   = post.updated_at
    end

    parts = [post_status_icon(post), phrase, date_tag(date, pubdate: "pubdate")]

    parts.join(" ").html_safe
  end

  #############################################################################
  # POLYMORPHIC WRAPPERS.
  #############################################################################

  def admin_url_for(instance, full_url: false)
    opts = [:admin, instance]

    full_url ? polymorphic_url(opts) : polymorphic_path(opts)
  end

  def admin_edit_url_for(instance, full_url: false)
    opts = [:admin, instance]

    full_url ? edit_polymorphic_url(opts) : edit_polymorphic_path(opts)
  end

  def admin_new_url_for(model, full_url: false)
    opts = [:admin, model]

    full_url ? new_polymorphic_url(opts) : new_polymorphic_path(opts)
  end

  def admin_list_url_for(model, full_url: false)
    opts = [:admin, model]

    full_url ? polymorphic_url(opts) : polymorphic_path(opts)
  end

  #############################################################################
  # LINKS.
  #############################################################################

  def admin_icon_link(icon, path, title, desc, **opts)
    svg = semantic_svg_image("open_iconic/#{icon}.svg", title: title, desc: desc)

    attrs = combine_attrs(opts, class: "admin-icon")

    link_to(svg, path, title: title, **attrs)
  end

  def admin_list_link(model)
    path  = admin_list_url_for(model)
    title = "back to #{model.model_name.plural} list"
    desc  = "list icon"
    icon  = "list"

    admin_icon_link(icon, path, title, desc, class: "list")
  end

  def admin_view_link(instance)
    path  = admin_url_for(instance)
    title = "view #{instance.model_name.singular}"
    desc  = "view icon"
    icon  = "eye"

    admin_icon_link(icon, path, title, desc, class: "view")
  end

  def admin_create_link(model)
    path  = admin_new_url_for(model)
    title = "create #{model.model_name.singular}"
    desc  = "create icon"
    icon  = "plus"

    admin_icon_link(icon, path, title, desc, class: "create")
  end

  def admin_update_link(instance)
    path  = admin_edit_url_for(instance)
    title = "update #{instance.model_name.singular}"
    desc  = "update icon"
    icon  = "pencil"

    admin_icon_link(icon, path, title, desc, class: "update")
  end

  def admin_destroy_link(instance)
    klass = instance.is_a?(Work) ? Work : instance.class

    return unless Pundit.policy!(current_user, [:admin, klass]).destroy?

    path  = admin_url_for(instance)
    title = "destroy #{instance.model_name.singular}"
    desc  = "trash icon"
    icon  = "trash"

    admin_icon_link(icon, path, title, desc, class: "destroy", method: :delete, "data-confirm": "Are you sure?")
  end

  def admin_public_link(instance)
    path = nil
    path = url_for_user(instance) if instance.is_a?(User)
    path = url_for_post(instance) if instance.is_a?(Post)

    return unless path

    title = "view #{instance.model_name.singular} on site"
    desc  = "public view icon"
    icon  = "link-intact"

    admin_icon_link(icon, path, title, desc, class: "public-view")
  end

  def should_link_to_admin_users?
    Pundit.policy!(current_user, [:admin, User]).index?
  end

  #############################################################################
  # TABLES.
  #############################################################################

  def status_icon_header
    svg_icon("eye", title: "Post Status", desc: "eye icon", wrapper_class: "admin-column-header")
  end

  def sortable_link(sorts, name, text: nil)
    text    = text || content_tag(:span, name)
    props   = sorts[name]
    classes = props[:active?] ? "active #{props[:desc?] ? 'desc' : 'asc'}" : nil

    link_to(text, props[:url], class: classes)
  end
end
