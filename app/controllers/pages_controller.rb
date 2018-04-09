class PagesController < ApplicationController
  before_action :authorize_page

  # GET /about
  def about; end

  # GET /credits
  def credits; end

private

  def authorize_page
    authorize :page, :show?
  end
end
