# frozen_string_literal: true

module FormHelper
  def required_indicator
    I18n.t("simple_form.required.html").html_safe
  end

  def summary_field(f)
    f.input :summary, required: false, hint: true, input_html: { class: "small" }
  end

  def slug_field(f)
    return unless f.object.persisted?

    f.input(:slug, readonly: true) + f.input(:clear_slug, as: :boolean)
  end

  def publish_date_fields(f)
    if f.object.published?
      f.input :published_at, as: :date, html5: true, readonly: true
    elsif f.object.persisted?
      f.input :publish_on,   as: :date, html5: true, hint: true
    end
  end
end
