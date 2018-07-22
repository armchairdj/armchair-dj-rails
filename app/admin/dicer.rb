# frozen_string_literal: true

class Dicer
  include ActionDispatch::Routing::PolymorphicRoutes
  include Rails.application.routes.url_helpers

  def initialize(current_scope, current_sort, current_dir)
    @current_scope = current_scope
    @current_sort  = current_sort
    @current_dir   = current_dir
  end

private

  def model_class
    raise NotImplementedError
  end

  def diced_url(scope, sort, dir)
    opts = { scope: scope, sort: sort, dir: dir }

    opts.compact!

    polymorphic_path [:admin, model_class], **opts
  end
end
