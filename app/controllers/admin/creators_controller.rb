# frozen_string_literal: true

class Admin::CreatorsController < Ginsu::Controller
  # POST /creators
  # POST /creators.json
  def create
    @creator.attributes = instance_params

    respond_to do |format|
      if @creator.save
        format.html { redirect_to show_path, success: I18n.t("admin.flash.creators.success.create") }
        format.json { render :show, status: :created, location: admin_creator_url(@creator) }
      else
        format.html { render_new }
        format.json { render json: @creator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /creators/1
  # PATCH/PUT /creators/1.json
  def update
    respond_to do |format|
      if @creator.update(instance_params)
        format.html { redirect_to show_path, success: I18n.t("admin.flash.creators.success.update") }
        format.json { render :show, status: :ok, location: admin_creator_url(@creator) }
      else
        format.html { render_edit }
        format.json { render json: @creator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /creators/1
  # DELETE /creators/1.json
  def destroy
    @creator.destroy

    respond_to do |format|
      format.html { redirect_to collection_path, success: I18n.t("admin.flash.creators.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def instance_params
    params.fetch(:creator, {}).permit(
      :name,
      :primary,
      :individual,
      links_attributes:                [
        :id,
        :_destroy,
        :url,
        :description
      ],
      pseudonym_identities_attributes: [
        :id,
        :_destroy,
        :real_name_id,
        :pseudonym_id
      ],
      real_name_identities_attributes: [
        :id,
        :_destroy,
        :pseudonym_id,
        :real_name_id
      ],
      member_memberships_attributes:   [
        :id,
        :_destroy,
        :group_id,
        :member_id
      ],
      group_memberships_attributes:    [
        :id,
        :_destroy,
        :member_id,
        :group_id
      ]
    )
  end

  def prepare_form
    @creator.prepare_for_editing

    @available_pseudonyms = @creator.available_pseudonyms
    @available_real_names = Creator.available_real_names
    @available_members    = Creator.available_members
    @available_groups     = Creator.available_groups
  end
end
