# frozen_string_literal: true

class Admin::CreatorsController < AdminController
  # GET /creators
  # GET /creators.json
  def index; end

  # GET /creators/1
  # GET /creators/1.json
  def show; end

  # GET /creators/new
  def new; end

  # GET /creators/1/edit
  def edit; end

  # POST /creators
  # POST /creators.json
  def create
    respond_to do |format|
      if @creator.save
        format.html { redirect_to admin_creator_path(@creator), success: I18n.t("admin.flash.creators.success.create") }
        format.json { render :show, status: :created, location: admin_creator_url(@creator) }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @creator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /creators/1
  # PATCH/PUT /creators/1.json
  def update
    respond_to do |format|
      if @creator.update(instance_params)
        format.html { redirect_to admin_creator_path(@creator), success: I18n.t("admin.flash.creators.success.update") }
        format.json { render :show, status: :ok, location: admin_creator_url(@creator) }
      else
        format.html { prepare_form; render :edit }
        format.json { render json: @creator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /creators/1
  # DELETE /creators/1.json
  def destroy
    @creator.destroy

    respond_to do |format|
      format.html { redirect_to admin_creators_path, success: I18n.t("admin.flash.creators.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @creators = scoped_and_sorted_collection
  end

  def build_new_instance
    @creator = Creator.new(instance_params)
  end

  def find_instance
    @creator = scoped_instance(params[:id])
  end

  def authorize_instance
    authorize @creator
  end

  def instance_params
    params.fetch(:creator, {}).permit(
      :name,
      :primary,
      :individual,
      :links_attributes => [
        :id,
        :_destroy,
        :url,
        :description
      ],
      :pseudonym_identities_attributes => [
        :id,
        :_destroy,
        :real_name_id,
        :pseudonym_id
      ],
      :real_name_identities_attributes => [
        :id,
        :_destroy,
        :pseudonym_id,
        :real_name_id
      ],
      :member_memberships_attributes => [
        :id,
        :_destroy,
        :group_id,
        :member_id
      ],
      :group_memberships_attributes => [
        :id,
        :_destroy,
        :member_id,
        :group_id
      ]
    )
  end

  def prepare_form
    @creator.prepare_pseudonym_identities
    @creator.prepare_real_name_identities
    @creator.prepare_member_memberships
    @creator.prepare_group_memberships

    @available_pseudonyms = @creator.available_pseudonyms
    @available_real_names = Creator.available_real_names
    @available_members    = Creator.available_members
    @available_groups     = Creator.available_groups
  end

  def allowed_sorts
    name_sort       = "LOWER(creators.name) ASC"
    primary_sort    = "creators.primary ASC"
    individual_sort = "creators.individual ASC"

    super(name_sort).merge({
      "Name"       => name_sort,
      "Primary"    => [primary_sort,    name_sort].join(", "),
      "Individual" => [individual_sort, name_sort].join(", "),
    })
  end
end
