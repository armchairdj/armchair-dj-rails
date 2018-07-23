# frozen_string_literal: true

class Dicer
  include ActionDispatch::Routing::PolymorphicRoutes
  include Rails.application.routes.url_helpers

  attr_reader :current_scope
  attr_reader :current_sort
  attr_reader :current_dir

  def initialize(current_scope: nil, current_sort: nil, current_dir: nil)
    @current_scope = current_scope
    @current_sort  = current_sort
    @current_dir   = current_dir
  end

private

  def validate
    return if valid?

    raise Pundit::NotAuthorizedError, invalid_msg
  end

  def valid?
    raise NotImplementedError
  end

  def invalid_msg
    raise NotImplementedError
  end

  def model_class
    raise NotImplementedError
  end

  def diced_url(scope, sort, dir)
    opts = { scope: scope, sort: sort, dir: dir }

    opts.compact!

    polymorphic_path [:admin, model_class], **opts
  end
end
