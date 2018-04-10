module SeoPaginatable
  extend ActiveSupport::Concern

  included do
    prepend_before_action :prevent_duplicate_first_page, only: [:index]
  end

private

  def prevent_duplicate_first_page
    return unless (params[:page] || "").to_s == "1"

    redirect_to polymorphic_path(controller_name.classify.constantize)
  end
end
