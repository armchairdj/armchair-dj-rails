# frozen_string_literal: true

class UsersController < ApplicationController
  # GET /profile/<friendly_id>
  # GET /profile/<friendly_id>.json
  def show
    @user = @instance = policy_scope(User).for_show.find_by!(username: params[:id])

    authorize @user
  end
end
