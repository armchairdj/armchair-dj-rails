# frozen_string_literal: true

module JsHelper
  def js_attrs(controller, opts = {})
    attrs = { class: opts.delete(:class), "data-controller": controller }

    opts.each.each_with_object(attrs) do |(key, val), memo|
      memo["data-#{controller}-#{key}"] = val; 
    end
  end

  def js_autosavable_attrs(post)
    opts = {}

    return opts unless post.persisted? && post.unpublished?

    opts[:url] = case post.class.name
      when "Article" then autosave_admin_article_path(post)
      when "Review"  then autosave_admin_review_path(post)
      when "Mixtape" then autosave_admin_mixtape_path(post)
    end

    js_attrs("autosavable", opts)
  end

  def js_selectabe_create_creator_attrs(scope = "creator")
    opts = {
      url:   admin_creators_path,
      scope: scope,
      param: "creator[name]"
    }

    opts["extra-params"] = case scope
      when "creator[real_name]" then "creator[primary]=true"
      when "creator[psuedonym]" then "creator[primary]=false"
      when "creator[member]"    then "creator[individual]=true"
      when "creator[group]"     then "creator[individual]=false"
    end

    js_attrs("creatable", opts)
  end

  def js_selectable_create_role_attrs
    opts = {
      "url":         admin_roles_path,
      "scope":       "role",
      "param":       "role[name]",
      "form-params": "role[medium]=work[medium]"
    }

    js_attrs("creatable", opts)
  end

  def js_selectable_create_aspect_attrs(facet)
    opts = {
      "url":          admin_aspects_path,
      "scope":        "aspect[facet=#{facet}]",
      "param":        "aspect[name]",
      "extra-params": "aspect[facet]=#{facet}"
    }

    js_attrs("creatable", opts).merge(multiple: true)
  end

  def js_selectable_create_tag_attrs
    opts = {
      url:   admin_tags_path,
      scope: "tag",
      param: "tag[name]"
    }

    js_attrs("creatable", opts).merge(multiple: true)
  end

  def js_selectable_prepare_work_attrs
    opts = {
      "tab-name":        "article-new-work",
      "title-selector":  "#article_work_attributes_title",
      "artist-selector": "#article_work_attributes_credits_attributes_0_creator_id"
    }

    js_attrs("selectable-prepare-work", opts)
  end

  def js_sortable_tracks_attrs(playlist)
    opts = {
      url:   reorder_tracks_admin_playlist_path(playlist),
      param: "track_ids",
      class: "numbered js-sortable"
    }

    js_attrs("sortable", opts)
  end

  def js_sortable_credits_attrs(work)
    opts = {
      url:   reorder_credits_admin_work_path(work),
      param: "credit_ids",
      class: "numbered sortable"
    }

    js_attrs("sortable", opts)
  end

  def js_tabbable_attrs(selected_tab)
    opts = {
      "selected-tab": selected_tab,
      "class":        "tabgroup same-page"
    }

    js_attrs("tabbable", opts)
  end

  def js_tabbable_link(text, tab_name)
    opts = {
      "data-action":   "tabbable#activate",
      "data-target":   "tabbable.all",
      "data-tab-name": tab_name
    }

    link_to(text, "##{tab_name}", opts)
  end

  def js_tabbable_tab_attrs(tab_name)
    {
      "id":            tab_name,
      "data-tab-name": tab_name,
      "data-target":   "tabbable.all",
      "class":         "tab"
    }
  end

  def js_togglable_attrs(bool, css_class, expandable:)
    klass  = bool ? "trueFieldset" : "falseFieldset"
    target = "togglable.#{klass}"
    attrs  = { class: css_class, "data-target": target }

    expandable ? js_attrs("expandable").merge(attrs) : attrs
  end

  def js_unmaskable_attrs
    {
      wrapper_html: {
        "data-controller": "unmaskable",
        "class":           "js-unmaskable"
      },
      input_html: {
        "data-target": "unmaskable.field",
        "data-action": "keydown->unmaskable#enable"
      }
    }
  end
end
