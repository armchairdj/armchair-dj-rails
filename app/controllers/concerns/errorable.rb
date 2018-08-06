# frozen_string_literal: true

################################################################################
# Add user-friendly error pages and developer-friendly logging to common errors.
# Used in conjunction with ErrorsController & config.exceptions_app & routes.
################################################################################

concern :Errorable do

  #############################################################################
  # INCLUDED.
  #############################################################################

  included do
    # 500: Global fallback must come first irst
    unless Rails.application.config.consider_all_requests_local
      rescue_from StandardError, with: :handle_500
    end

    # 403
    rescue_from Pundit::NotAuthorizedError,    with: :handle_403
    rescue_from Pundit::NotAuthenticatedError, with: :handle_403_recoverable

    # 404
    rescue_from ActiveRecord::RecordNotFound,        with: :handle_404
    rescue_from ActionController::RoutingError,      with: :handle_404
    rescue_from AbstractController::ActionNotFound,  with: :handle_404

    # 422
    rescue_from ActionController::UnknownFormat,            with: :handle_422
    rescue_from ActionController::InvalidAuthenticityToken, with: :handle_422
    rescue_from ActionController::UnpermittedParameters,    with: :handle_422

  protected

    def handle_403_recoverable(exception = nil)
      return render_error_json(403) if request.xhr?

      respond_to do |format|
        format.html { set_user_return_to; require_login }
        format.json { render_error_json(403) }
      end
    end

    def handle_403(exception = nil)
      respond_with_error(403, :permission_denied, exception)
    end

    def handle_404(exception = nil)
      respond_with_error(404, :not_found, exception)
    end

    def handle_422(exception = nil)
      respond_with_error(422, :bad_request, exception)
    end

    def handle_500(exception = nil)
      respond_with_error(500, :internal_server_error, exception)
    end

    def respond_with_error(code, template, exception = nil)
      render_error_response(code, template)

      log_error(code, exception)
    end

    def render_error_response(code, template)
      return render_error_json(code) if request.xhr?

      respond_to do |format|
        format.html { render_error_template(code, template) }
        format.json { render_error_json(code) }
      end
    end

    def render_error_template(code, template)
      # errors/bad_request
      # errors/internal_server_error
      # errors/not_found
      # errors/permission_denied
      render template: "errors/#{template}", status: code, layout: "error"
    end

    def render_error_json(code)
      render json: {}, status: code
    end

  private

    def set_user_return_to
      if request.get? && !request.xhr?
        session["user_return_to"] = request.url
      end
    end

    def require_login
      notice = I18n.t("public.flash.sessions.error.missing")

      redirect_to(new_user_session_path, notice: notice)
    end

    def log_error(code, exception = nil)
      parts = [error_id(code), url_str, user_str, exception.try(:message)]

      logger.error parts.compact.join(" :: ")
    end

    def error_id(code)
      case code
      when 403; "FORBIDDEN_ERROR (403)"
      when 404; "NOT_FOUND_ERROR (404)"
      when 422; "BAD_REQUEST_ERROR (422)"
      when 500; "WHOOPS_EXCEPTION (500)"
      else;     "UNKNOWN_EXCEPTION"
      end
    end

    def url_str
      request.try(:url) || "unknown URL"
    end

    def user_str
      return "guest user" unless user_signed_in?

      "User ##{current_user.id} [#{current_user.email}]"
    end
  end
end
