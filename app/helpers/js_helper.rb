# frozen_string_literal: true

module JsHelper
  def js_attrs(controller, opts = {})
    attrs = { class: opts.delete(:class), "data-controller": controller }

    opts.each.inject(attrs) do |memo, (key, val)|
      memo["data-#{controller}-#{key}"] = val; memo
    end

    attrs
  end

  def js_autosave_attrs(post)
    return {} unless post.persisted? && post.unpublished?

    opts = {}

    opts[:url] = case post.class.name
      when "Article"; autosave_admin_article_path(post)
      when "Review";  autosave_admin_review_path( post)
      when "Mixtape"; autosave_admin_mixtape_path(post)
    end

    js_attrs("autosave", opts)
  end

  def js_selectabe_create_creator_attrs(scope = "creator")
    opts = { scope: scope, url: admin_creators_path, param: "creator[name]" }

    opts["extra-params"] = case scope
      when "creator[real_name]"; "creator[primary]=true"
      when "creator[psuedonym]"; "creator[primary]=false"
      when "creator[member]";    "creator[individual]=true"
      when "creator[group]";     "creator[individual]=false"
    end unless scope.nil?

    js_attrs("selectable-create", opts)
  end

  def js_selectable_create_role_attrs
    opts = {
      scope:         "role",
      url:           admin_roles_path,
      param:         "role[name]",
      "form-params": "role[medium]=work[medium]"
    }

    js_attrs("selectable-create", opts)
  end

  def js_selectable_create_aspect_attrs(facet)
    opts = {
      "url":          admin_aspects_path,
      "param":        "aspect[name]",
      "scope":        "aspect[facet=#{facet}]",
      "extra-params": "aspect[facet]=#{facet}",
    }

    js_attrs("selectable-create", opts).merge(multiple: true)
  end

  def js_selectable_create_tag_attrs
    opts = { scope: "tag", url: admin_tags_path, param: "tag[name]" }

    js_attrs("selectable-create", opts).merge(multiple: true)
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
      class: "numbered sortable",
      param: "track_ids",
      url:   reorder_tracks_admin_playlist_path(playlist)
    }

    js_attrs("sortable", opts)
  end

  def js_sortable_credits_attrs(work)
    opts = {
      class: "numbered sortable",
      param: "credit_ids",
      url:   reorder_credits_admin_work_path(work)
    }

    js_attrs("sortable", opts)
  end

  def js_tabbable_attrs(selected_tab)
    opts = {
      "selected-tab": selected_tab,
      class:          "tabgroup same-page"
    }

    js_attrs("tabbable", opts)
  end

  def js_tabbable_link(text, tab_name)
    link_to text, "##{tab_name}",
      "data-action":   "click->tabbable#activate",
      "data-tab-name": tab_name,
      "data-target":   "tabbable.all"
  end

  def js_tabbable_tab_attrs(tab_name)
    {
      class:           "tab",
      id:              tab_name,
      "data-tab-name": tab_name,
      "data-target":   "tabbable.all",
    }
  end

  def js_togglable_attrs(bool, css_class, expandable:)
    target = "togglable-fieldset.#{bool ? 'trueFieldset' : 'falseFieldset'}"
    attrs  = { class: css_class, "data-target": target }

    expandable ? js_attrs("expandable-fieldset").merge(attrs) : attrs
  end
end
