# frozen_string_literal: true

class PagesController < ApplicationController

  # GET /about
  # GET /contact
  # GET /credits
  # GET /privacy
  # GET /terms
  def show
    render params[:template]
  end
end
