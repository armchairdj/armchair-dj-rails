class PagesController < ApplicationController
  before_action :authorize_page

  # GET /
  def homepage
    @homepage = true
  end

private

  def authorize_page
    authorize :page, :show?
  end
end
