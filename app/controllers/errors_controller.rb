# frozen_string_literal: true

class ErrorsController < ApplicationController
  def permission_denied
    render_error_response(403, :permission_denied)
  end

  def not_found
    render_error_response(404, :not_found)
  end

  def bad_request
    render_error_response(422, :bad_request)
  end

  def internal_server_error
    render_error_response(500, :internal_server_error)
  end
end
