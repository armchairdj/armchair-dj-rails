class Admin::TagsController < Admin::BaseController

  # POST /admin/tags
  # POST /admin/tags.json
  def create
    @tag.attributes = instance_params

    respond_to do |format|
      if @tag.save
        format.html { redirect_to show_path, success: I18n.t("admin.flash.tags.success.create") }
        format.json { render :show, status: :created, location: admin_tag_url(@tag) }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/tags/1
  # PATCH/PUT /admin/tags/1.json
  def update
    respond_to do |format|
      if @tag.update(instance_params)
        format.html { redirect_to show_path, success: I18n.t("admin.flash.tags.success.update") }
        format.json { render :show, status: :ok, location: admin_tag_url(@tag) }
      else
        format.html { prepare_form; render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/tags/1
  # DELETE /admin/tags/1.json
  def destroy
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to collection_path, success: I18n.t("admin.flash.tags.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def instance_params
    params.fetch(:tag, {}).permit(
      :name,
    )
  end

  def allowed_sorts
    { "Name" => [name_sort] }
  end
end
