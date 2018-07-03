# frozen_string_literal: true

module Paginatable
  extend ActiveSupport::Concern

  included do
    prepend_before_action :prevent_duplicate_first_page, only: [:index]
  end

private

  def prevent_duplicate_first_page
    return unless (params[:page] || "").to_s == "1"

    namespace   = self.class.parent.name.downcase.to_sym
    # This is a hack because we Admin::Posts is namespaces 2 levels but the
    # routes are only nested on level (to /admin)
    url_options = namespace == :object ? model_class : [:admin, model_class]

    redirect_to polymorphic_path(url_options), status: 301
  end
end
