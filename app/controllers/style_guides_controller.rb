class StyleGuidesController < ApplicationController
  before_action :set_template,   only: [:show         ]
  before_action :set_flash_type, only: [:flash_message]
  before_action :set_error_type, only: [:error_page   ]

  def index; end

  def show
    render @template
  end

  def flash_message
    flash.now[@flash_type] = "This is a flash #{@flash_type.to_sym} message."
  end

  def error_page
    render_error_response(200, @error_type)
  end

private

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
