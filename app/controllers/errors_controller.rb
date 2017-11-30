class ErrorsController < ApplicationController
  def not_found
    render_error_response(404, :not_found)
  end

  def internal_server_error
    render_error_response(500, :internal_server_error)
  end
end
