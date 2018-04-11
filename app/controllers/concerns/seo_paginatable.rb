module SeoPaginatable
  extend ActiveSupport::Concern

  included do
    prepend_before_action :prevent_duplicate_first_page, only: [:index]
  end

private

  def prevent_duplicate_first_page
    return unless (params[:page] || "").to_s == "1"

    const       = controller_name.classify.constantize
    parent      = self.class.parent
    url_options = parent == Object ? const : [parent.name.downcase.to_sym, const]

    redirect_to polymorphic_path(url_options), status: 301
  end
end
