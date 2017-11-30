class PagesController < ApplicationController

  # GET /
  def index
    # flash.now[:error] = "This is an error message."
    # flash.now[:notice] = "This is a notice message."

    @homepage = true
  end

end
