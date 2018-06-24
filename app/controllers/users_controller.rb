# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_instance, only: [
    :show
  ]

  before_action :authorize_instance, only: [
    :show
  ]

  # GET /profile/<friendly_id>
  # GET /profile/<friendly_id>.json
  def show; end

private

  def find_instance
    @user = @instance = policy_scope(User).find_by(username: params[:id])
  end

  def authorize_instance
    authorize @user
  end
end
