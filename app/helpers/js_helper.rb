# frozen_string_literal: true

module JsHelper
  def js_attrs(controller, hash = nil, **opts)
    opts = hash.merge(opts) unless hash.nil?

    attrs = { class: opts.delete(:class), "data-controller": controller }

    opts.each.inject(attrs) do |memo, (key, val)|
      memo["data-#{controller}-#{key}"] = val; memo
    end

    attrs
  end

  def js_selectabe_create_creator_attrs(scope = "creator")
    attrs = { scope: scope, url: admin_creators_path, param: "creator[name]" }

    attrs["extra-params"] = case scope
      when "creator[real_name]"; "creator[primary]=true"
      when "creator[psuedonym]"; "creator[primary]=false"
      when "creator[member]";    "creator[individual]=true"
      when "creator[group]";     "creator[individual]=false"
    end unless scope.nil?

    js_attrs("selectable-create", attrs)
  end

  def js_selectable_create_role_attrs
    attrs = {
      scope: "role", url: admin_roles_path, param: "role[name]",
      "form-params": "role[medium]=work[medium]"
    }

    js_attrs("selectable-create", attrs)
  end

  def js_selectable_create_aspect_attrs(facet)
    attrs = {
      "url":          admin_aspects_path,
      "param":        "aspect[name]",
      "scope":        "aspect[facet=#{facet}]",
      "extra-params": "aspect[facet]=#{facet}",
    }

    js_attrs("selectable-create", attrs).merge(multiple: true)
  end

  def js_selectable_create_tag_attrs
    attrs = { scope: "tag", url: admin_tags_path, param: "tag[name]" }

    js_attrs("selectable-create", attrs).merge(multiple: true)
  end

  def js_selectable_prepare_work_attrs
    js_attrs("selectable-prepare-work",
      "tab-name":        "article-new-work",
      "title-selector":  "#article_work_attributes_title",
      "artist-selector": "#article_work_attributes_credits_attributes_0_creator_id"
    )
  end

  def js_sortable_playlistings_attrs(playlist)
    js_attrs("sortable",
      class: "numbered sortable",
      param: "playlisting_ids",
      url:   reorder_playlistings_admin_playlist_path(playlist)
    )
  end

  def js_tabbable_attrs(selected_tab)
    js_attrs("tabbable", "selected-tab": selected_tab, class: "tabgroup same-page")
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

    expandable ? attrs.merge(js_attrs("expandable-fieldset")) : attrs
  end
end
