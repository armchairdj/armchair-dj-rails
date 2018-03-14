class PagesController < ApplicationController

  # GET /
  def index
    # raise StandardError
    # raise ActiveRecord::RecordNotFound
    # raise Pundit::NotAuthorizedError

    @homepage = true
  end

  def style_guide
    flash.now[:error]  = "This is an error message."
    flash.now[:notice] = "This is a notice message."

  end
end
