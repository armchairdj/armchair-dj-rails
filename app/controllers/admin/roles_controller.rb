class Admin::RolesController < Ginsu::Controller

  # POST /admin/roles
  # POST /admin/roles.json
  def create
    @role.attributes = instance_params

    respond_to do |format|
      if @role.save
        format.html { redirect_to show_path, success: I18n.t("admin.flash.roles.success.create") }
        format.json { render :show, status: :created, location: admin_role_url(@role) }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/roles/1
  # PATCH/PUT /admin/roles/1.json
  def update
    respond_to do |format|
      if @role.update(instance_params)
        format.html { redirect_to show_path, success: I18n.t("admin.flash.roles.success.update") }
        format.json { render :show, status: :ok, location: admin_role_url(@role) }
      else
        format.html { prepare_form; render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/roles/1
  # DELETE /admin/roles/1.json
  def destroy
    @role.destroy

    respond_to do |format|
      format.html { redirect_to collection_path, success: I18n.t("admin.flash.roles.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def instance_params
    params.fetch(:role, {}).permit(
      :name,
      :medium
    )
  end

  def prepare_form
    @media = Work.media
  end
end
