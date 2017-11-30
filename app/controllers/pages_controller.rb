class PagesController < ApplicationController

  # GET /
  def index
    # raise StandardError
    # raise ActiveRecord::RecordNotFound
    # raise Pundit::NotAuthorizedError
    # flash.now[:error] = "This is an error message."
    # flash.now[:notice] = "This is a notice message."

    @homepage = true
  end

end
