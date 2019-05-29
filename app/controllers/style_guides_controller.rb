# frozen_string_literal: true

class StyleGuidesController < ApplicationController
  before_action :authorize_page

  def index; end

  def show
    @template = params[:template]

    render @template
  end

  def flash_message
    @flash_type = params[:flash_type].to_sym

    flash.now[@flash_type] = "This is a flash #{@flash_type} message."
  end

  def error_page
    @error_type = params[:error_type].to_sym

    render_error_response(200, @error_type)
  end

  private

  def determine_layout
    "admin"
  end

  def authorize_page
    authorize :style_guide, :show?
  end
end
