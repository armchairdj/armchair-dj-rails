################################################################################
# Add user-friendly error pages and developer-friendly logging to common errors.
# Used in conjunction with ErrorsController & config.exceptions_app & routes.
################################################################################

module HandleErrors
  extend ActiveSupport::Concern

  included do
    # 403
    rescue_from Pundit::AuthorizationNotPerformedError, with: :handle_403_recoverable
    rescue_from Pundit::NotAuthorizedError,             with: :handle_403

    # 404
    rescue_from ActiveRecord::RecordNotFound,           with: :handle_404
    rescue_from ActionController::RoutingError,         with: :handle_404
    rescue_from ActionController::UnknownController,    with: :handle_404
    rescue_from AbstractController::ActionNotFound,     with: :handle_404

  protected

    def handle_403_recoverable(exception = nil)
      return handle_403(exception) if request.xhr?

      set_user_return_to

      redirect_to(new_user_session_path, notice: I18n.t("session.missing"))
    end

    def handle_403(exception = nil)
      set_user_return_to

      respond_with_error(403, :permission_denied, exception)
    end

    def handle_404(exception = nil)
      respond_with_error(404, :not_found, exception)
    end

    def handle_500(exception = nil)
      respond_with_error(500, :internal_server_error, exception)
    end

    def set_user_return_to
      if request.get? && !request.xhr?
        session["user_return_to"] = request.url
      end
    end

    def respond_with_error(code, template, exception = nil)
      render_error_response(code, template)
      log_error(code, exception)

      false
    end

    def render_error_response(code, template)
      if request.xhr?
        return render json: {}, status: code
      end

      # errors/internal_server_error
      # errors/not_found
      # errors/permission_denied
      render template: "errors/#{template}", status: code, layout: "error"
    end

  private

    def log_error(code, exception = nil)
      logger.error [
        error_identifier(code),
        url_identifier,
        user_identifier,
        exception
      ].compact.join(" :: ")
    end

    def error_identifier(code)
      case code
      when 500
        "ARMCHAIRDJ_WHOOPS (500)"
      when 404
        "ARMCHAIRDJ_NOT_FOUND (404)"
      when 403
        "ARMCHAIRDJ_FORBIDDEN (403)"
      else
        "ARMCHAIRDJ_EXCEPTION (#{code})"
      end
    end

    def url_identifier
      request.url.present? ? request.url : "unknown URL"
    end

    def user_identifier
      user_signed_in? ? "#{current_user.id} [#{current_user.email}]" : "guest user"
    end
  end
end
