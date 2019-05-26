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
        format.html do
          set_user_return_to
          require_login
        end

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

    def respond_with_error(status, template, exception = nil)
      render_error_response(status, template)

      log_error(exception, status)
    end

    def render_error_response(status, template)
      return render_error_json(status) if request.xhr?

      respond_to do |format|
        format.html { render_error_template(status, template) }
        format.json { render_error_json(status) }
      end
    end

    def render_error_template(status, template)
      # errors/bad_request
      # errors/internal_server_error
      # errors/not_found
      # errors/permission_denied
      render template: "errors/#{template}", status: status, layout: "error"
    end

    def render_error_json(status)
      render json: {}, status: status
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

    def log_error(exception = nil, status = nil, logger_method = :error)
      logger.send(logger_method, logger_message(status, exception))
    end

    def logger_message(status, exception)
      summary = loggable_summary(status, exception)

      if exception.present? && status == 500
        exception.backtrace.unshift(summary).join("\n")
      else
        summary
      end
    end

    def loggable_summary(status, exception)
      [
        loggable_token(status),
        loggable_verb,
        loggable_url,
        loggable_user,
        exception.try(:message)
      ].compact.join(" :: ")
    end

    def loggable_token(status)
      case status
      when 403 then "FORBIDDEN_ERROR (403)"
      when 404 then "NOT_FOUND_ERROR (404)"
      when 422 then "BAD_REQUEST_ERROR (422)"
      when 500 then "WHOOPS_EXCEPTION (500)"
      else
        "UNKNOWN_EXCEPTION"
      end
    end

    def loggable_verb
      request.try(:request_method) || "unknown verb"
    end

    def loggable_url
      request.try(:url) || "unknown URL"
    end

    def loggable_user
      return "guest user" unless user_signed_in?

      id    = current_user.try(:id)    || "unknown"
      role  = current_user.try(:role)  || "unknown"
      email = current_user.try(:email) || "unknown"

      "{ id: #{id}, email: #{email}, role: #{role} }"
    end
  end
end
