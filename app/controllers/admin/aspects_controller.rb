# frozen_string_literal: true

class Admin::AspectsController < Ginsu::Controller

  # POST /admin/aspects
  # POST /admin/aspects.json
  def create
    @aspect.attributes = instance_params

    respond_to do |format|
      if @aspect.save
        format.html { redirect_to show_path, success: I18n.t("admin.flash.aspects.success.create") }
        format.json { render :show, status: :created, location: admin_aspect_url(@aspect) }
      else
        format.html { render_new }
        format.json { render json: @aspect.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/aspects/1
  # PATCH/PUT /admin/aspects/1.json
  def update
    respond_to do |format|
      if @aspect.update(instance_params)
        format.html { redirect_to show_path, success: I18n.t("admin.flash.aspects.success.update") }
        format.json { render :show, status: :ok, location: admin_aspect_url(@aspect) }
      else
        format.html { render_edit }
        format.json { render json: @aspect.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/aspects/1
  # DELETE /admin/aspects/1.json
  def destroy
    @aspect.destroy

    respond_to do |format|
      format.html { redirect_to collection_path, success: I18n.t("admin.flash.aspects.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def instance_params
    params.fetch(:aspect, {}).permit(
      :name,
      :facet
    )
  end

  def prepare_form
    @facets = Aspect.human_facets
  end
end
