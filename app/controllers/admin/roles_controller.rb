class Admin::RolesController < AdminController

  # GET /admin/roles
  # GET /admin/roles.json
  def index; end

  # GET /admin/roles/1
  # GET /admin/roles/1.json
  def show; end

  # GET /admin/roles/new
  def new; end

  # POST /admin/roles
  # POST /admin/roles.json
  def create
    respond_to do |format|
      if @role.save
        format.html { redirect_to admin_role_path(@role), success: I18n.t("admin.flash.roles.success.create") }
        format.json { render :show, status: :created, location: admin_role_url(@role) }
      else
        format.html { prepare_form; render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /admin/roles/1/edit
  def edit; end

  # PATCH/PUT /admin/roles/1
  # PATCH/PUT /admin/roles/1.json
  def update
    respond_to do |format|
      if @role.update(instance_params)
        format.html { redirect_to admin_role_path(@role), success: I18n.t("admin.flash.roles.success.update") }
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
      format.html { redirect_to admin_roles_path, success: I18n.t("admin.flash.roles.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @roles = scoped_and_sorted_collection
  end

  def build_new_instance
    @role = Role.new(instance_params)
  end

  def find_instance
    @role = scoped_instance(params[:id])
  end

  def authorize_instance
    authorize @role
  end

  def instance_params
    params.fetch(:role, {}).permit(
      :name,
      :work_type
    )
  end

  def prepare_form
    @work_types = Work.type_options
  end

  def allowed_sorts
    name_sort   = "LOWER(roles.name) ASC"
    medium_sort = "LOWER(roles.work_type) ASC"

    super(name_sort).merge({
      "Name"   => [name_sort, medium_sort].join(", "),
      "Medium" => [medium_sort, name_sort].join(", "),
    })
  end
end
