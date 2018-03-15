class StyleGuidesController < ApplicationController

  def list; end

  def post; end

  #############################################################################
  # Forms.
  #############################################################################

  def button; end

  def form; end

  def form_with_errors; end

  #############################################################################
  # Flash messages.
  #############################################################################

  def flash_alert
    flash.now[:alert]  = "This is a flash alert."

    render :flash
  end

  def flash_error
    flash.now[:error]  = "This is a flash error."

    render :flash
  end

  def flash_info
    flash.now[:fino]  = "This is a flash info message."

    render :flash
  end

  def flash_notice
    flash.now[:notice] = "This is a flash notice."

    render :flash
  end

  def flash_success
    flash.now[:success] = "This is a flash success message."

    render :flash
  end

  #############################################################################
  # Errors.
  #############################################################################

  def internal_server_error
    raise StandardError
  end

  def not_found
    raise ActiveRecord::RecordNotFound
  end

  def permission_denied
    raise Pundit::NotAuthorizedError
  end
end
