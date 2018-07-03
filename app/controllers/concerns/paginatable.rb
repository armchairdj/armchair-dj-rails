# frozen_string_literal: true

module Paginatable
  extend ActiveSupport::Concern

  included do
    prepend_before_action :prevent_duplicate_first_page, only: [:index]
  end

private

  def prevent_duplicate_first_page
    return unless (params[:page] || "").to_s == "1"

    url_options = self.class < Admin::BaseController ? [:admin, model_class] : model_class

    redirect_to polymorphic_path(url_options), status: 301
  end
end
