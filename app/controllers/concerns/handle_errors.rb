################################################################################
# Add user-friendly error pages and developer-friendly logging to common errors.
################################################################################

module HandleErrors
  extend ActiveSupport::Concern

  included do
    # 500
    unless Rails.application.config.consider_all_requests_local
      rescue_from StandardError,                     with: :handle_500
    end

    # 404
    rescue_from ActiveRecord::RecordNotFound,        with: :handle_404
    rescue_from ActionController::RoutingError,      with: :handle_404
    rescue_from ActionController::UnknownController, with: :handle_404
    rescue_from AbstractController::ActionNotFound,  with: :handle_404

    # 403
    rescue_from Pundit::NotAuthorizedError,          with: :handle_403

  protected

    def handle_500(exception = nil)
      respond_with_error(500, "whoops", exception)
    end

    def handle_404(exception = nil)
      respond_with_error(404, "where_now", exception)
    end

    def handle_403(exception = nil)
      set_user_return_to

      respond_with_error(403, "whoa_there", exception)
    end

    def set_user_return_to
      if request.get? && !request.xhr?
        session["user_return_to"] = request.url
      end
    end

    def respond_with_error(code, template, exception = nil)
      render_response(code, template)
      log_error(code, exception)

      false
    end

    def render_response(code, template)
      if request.xhr?
        return render json: {}, status: code
      end

      # errors/whoops
      # errors/where_now
      # errors/whoa_there
      render template: "errors/#{template}", status: code, layout: "error"
    end

    def log_error(code, exception = nil)
      logger.error [
        log_identifier(code),
        request.url.present? ? request.url                                  : "mystery URL",
        user_signed_in?      ? "#{current_user.id} [#{current_user.email}]" : "guest user",
        exception
      ].compact.join(" :: ")
    end

    def log_identifier(code)
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
