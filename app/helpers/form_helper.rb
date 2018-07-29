# frozen_string_literal: true

module FormHelper
  def button_group(content = nil, &block)
    content ||= capture(&block)

    content_tag :div, content, class: "button-group"
  end

  def confirm_button(obj = nil, text = nil, **opts)
    opts = combine_attrs(opts, { class: "danger", "data-confirm": "Are you sure?" })

    submit_button obj, text, **opts
  end

  def required_indicator
    I18n.t("simple_form.required.html").html_safe
  end

  def submit_button(obj = nil, text = nil, **opts)
    text ||= obj.new_record? ? "Save" : "Save Changes"

    button_tag text, type: :submit, **opts
  end
end
