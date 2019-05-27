# frozen_string_literal: true

concern :Paginatable do
  #############################################################################
  # INCLUDED.
  #############################################################################

  included do
    prepend_before_action :prevent_duplicate_first_page, only: [:index]
  end

  #############################################################################
  # INSTANCE.
  #############################################################################

private

  def prevent_duplicate_first_page
    return unless (params[:page] || "").to_s == "1"

    model_class = determine_model_class

    # TODO: Generalize logic for figuring out route namespace.
    #      We can't just use the controller namespace because the
    #      route namespace may be different & polymorphic_path
    #      relies on routes, not controllers.
    url_options = self.class < Ginsu::Controller ? [:admin, model_class] : model_class

    redirect_to polymorphic_path(url_options), status: 301
  end
end
