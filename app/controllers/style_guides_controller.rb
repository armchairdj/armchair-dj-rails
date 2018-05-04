# frozen_string_literal: true

class StyleGuidesController < ApplicationController
  before_action :is_admin
  before_action :authorize_page
  before_action :set_template,   only: [:show         ]
  before_action :set_flash_type, only: [:flash_message]
  before_action :set_error_type, only: [:error_page   ]

  def index; end

  def show
    render @template
  end

  def flash_message
    flash.now[@flash_type] = "This is a flash #{@flash_type} message."
  end

  def error_page
    render_error_response(200, @error_type)
  end

private

  def determine_layout
    "admin"
  end

  def is_admin
    @admin = true
  end

  def authorize_page
    authorize :style_guide, :show?
  end

  def set_template
    @template = params[:template]
  end

  def set_flash_type
    @flash_type = params[:flash_type].to_sym
  end

  def set_error_type
    @error_type = params[:error_type].to_sym
  end
end
