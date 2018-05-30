# frozen_string_literal: true

module JsHelper
  def js_attrs(controller, hash = nil, **opts)
    opts = hash.merge(opts) unless hash.nil?

    attrs = { "data-controller": controller }

    opts.each.inject(attrs) do |memo, (key, val)|
      memo["data-#{controller}-#{key}"] = val; memo
    end

    attrs
  end

  def js_selectable_create_category_attrs(scope = "category")
    attrs = { scope: scope, url: admin_categories_path, param: "category[name]" }

    js_attrs("selectable-create", attrs)
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
    attrs = { scope: "role", url: admin_roles_path, param: "role[name]", "form-params": "role[medium_id]=work[medium_id]" }

    js_attrs("selectable-create", attrs)
  end

  def js_selectable_create_tag_attrs(category = nil)
    attrs = { scope: "tag", url: admin_tags_path, param: "tag[name]" }

    unless category.nil?
      attrs["scope"       ] = "tag[category_id=#{category.id}]"
      attrs["extra-params"] = "tag[category_id]=#{category.id}"

      if category.allow_multiple?
        params["allow-range"] = "true" if category.year?
      else
        params["max-items"  ] = "1"
      end
    end

    js_attrs("selectable-create", attrs).merge(multiple: true)
  end

  def js_tabbable_link(text, tab_name)
    link_to text, "##{tab_name}",
      "data-target":   "tabbable.all",
      "data-action":   "click->tabbable#activate",
      "data-tab-name": tab_name
  end

  def js_tabbable_tab_attrs(tab_name)
    {
      class:           "tab",
      id:              tab_name,
      "data-tab-name": tab_name,
      "data-target":   "tabbable.all",
    }
  end
end
