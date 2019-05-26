# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: [
    :edit,
    :update,
    :edit_password,
    :update_password,
    :destroy
  ]

  prepend_before_action :set_minimum_password_length, only: [
    :new,
    :create,
    :edit,
    :update,
    :edit_password,
    :update_password
  ]

  before_action :configure_sign_up_params, only: [
    :create
  ]

  before_action :configure_account_update_params, only: [
    :update
  ]

  before_action :configure_password_update_params, only: [
    :update_password
  ]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    resource.prepare_links

    super
  end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  def destroy
    resource.destroy

    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    set_flash_message! :notice, :destroyed

    yield resource if block_given?

    respond_with_navigational(resource) { redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # GET /users/change_password
  def edit_password

  end

  # PUT /users/change_password
  def update_password
    self.resource = current_user

    resource_updated = update_resource(resource, account_update_params)

    if resource_updated
      if is_flashing_format?
        set_flash_message :notice, :updated_password
      end

      bypass_sign_in resource, scope: resource_name

      redirect_to settings_path
    else
      clean_up_passwords resource

      render :edit_password
    end
  end

protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up) do |user|
      user.permit(
        :first_name,
        :last_name,
        :middle_name,
        :email,
        :username,
        :password
      )
    end
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update) do |user|
      user.permit(
        :first_name,
        :last_name,
        :middle_name,
        :email,
        :username,
        :bio,
        :current_password
      )
    end
  end

  def configure_password_update_params
    devise_parameter_sanitizer.permit(:account_update) do |user|
      user.permit(
        :password,
        :current_password
      )
    end
  end

  def after_sign_up_path_for(resource)
    articles_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
