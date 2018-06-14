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
    url_options = namespace == :object ? model_class : [namespace, model_class]

    redirect_to polymorphic_path(url_options), status: 301
  end
end
