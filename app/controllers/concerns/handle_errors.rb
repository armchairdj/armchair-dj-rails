################################################################################
# Add user-friendly error pages and developer-friendly logging to common errors.
# Used in conjunction with ErrorsController & config.exceptions_app & routes.
################################################################################

module HandleErrors
  extend ActiveSupport::Concern

  included do
    # 403
    rescue_from Pundit::NotAuthorizedError,          with: :handle_403

    # 404
    rescue_from ActiveRecord::RecordNotFound,        with: :handle_404
    rescue_from ActionController::RoutingError,      with: :handle_404
    rescue_from ActionController::UnknownController, with: :handle_404
    rescue_from AbstractController::ActionNotFound,  with: :handle_404
  protected

    def handle_500(exception = nil)
      logger.info "handle_500"

      respond_with_error(500, :internal_server_error, exception)
    end

    def handle_404(exception = nil)
      logger.info "handle_404"

      respond_with_error(404, :not_found, exception)
    end

    def handle_403(exception = nil)
      set_user_return_to

      logger.info "handle_403"

      respond_with_error(403, :permission_denied, exception)
    end

    def user_signed_in?
      false
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
        log_error_identifier(code),
        request.url.present? ? request.url                                  : "mystery URL",
        user_signed_in?      ? "#{current_user.id} [#{current_user.email}]" : "guest user",
        exception
      ].compact.join(" :: ")
    end

    def log_error_identifier(code)
      case code
      when 500
        "ARMCHAIRDJ_EXCEPTION (500)"
      when 404
        "ARMCHAIRDJ_NOT_FOUND (404)"
      when 403
        "ARMCHAIRDJ_FORBIDDEN (403)"
      end
    end
  end
end
