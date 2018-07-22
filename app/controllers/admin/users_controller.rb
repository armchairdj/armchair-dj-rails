# frozen_string_literal: true

class Admin::UsersController < Admin::BaseController

  # POST /users
  # POST /users.json
  def create
    @user.attributes = instance_params

    respond_to do |format|
      if current_user.valid_role_assignment_for?(@user) && @user.save
        format.html { redirect_to show_path, success: I18n.t("admin.flash.users.success.create") }
        format.json { render :show, status: :created, location: admin_user_url(@user) }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user.attributes = instance_params

    respond_to do |format|
      if current_user.valid_role_assignment_for?(@user) && @user.save
        format.html { redirect_to show_path, success: I18n.t("admin.flash.users.success.update") }
        format.json { render :show, status: :ok, location: admin_user_url(@user) }
      else
        format.html { prepare_form; render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to collection_path, success: I18n.t("admin.flash.users.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def scoped_instance
    policy_scope(model_class).for_show.find_by!(username: params[:id])
  end

  def instance_params
    fetched = params.fetch(:user, {}).permit(
      :first_name,
      :last_name,
      :middle_name,
      :email,
      :username,
      :password,
      :role,
      :bio,
      :links_attributes => [
        :id,
        :_destroy,
        :url,
        :description
      ],
    )
  end

  def prepare_form
    @user.prepare_links

    @roles = current_user.assignable_role_options
  end

  def prepare_show
    @links = @user.links
  end
end
