# frozen_string_literal: true

module FormHelper
  def required_indicator
    I18n.t("simple_form.required.html").html_safe
  end
end
