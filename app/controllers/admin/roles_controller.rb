class Admin::RolesController < AdminController
  before_action :authorize_collection, only: [
    :index,
    :new,
    :create
  ]

  before_action :find_collection, only: [
    :index
  ]

  before_action :build_new_instance, only: [
    :new,
    :create
  ]

  before_action :find_instance, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  before_action :authorize_instance, only: [
    :show,
    :edit,
    :update,
    :destroy
  ]

  # GET /admin/roles
  # GET /admin/roles.json
  def index

  end

  # GET /admin/roles/1
  # GET /admin/roles/1.json
  def show

  end

  # GET /admin/roles/new
  def new

  end

  # POST /admin/roles
  # POST /admin/roles.json
  def create
    respond_to do |format|
      if @admin_role.save
        format.html { redirect_to @admin_role, success: I18n.t("#{singular_table_name}.success.create") }
        format.json { render :show, status: :created, location: @admin_role }
      else
        format.html { render :new }
        format.json { render json: @admin_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /admin/roles/1/edit
  def edit

  end

  # PATCH/PUT /admin/roles/1
  # PATCH/PUT /admin/roles/1.json
  def update
    respond_to do |format|
      if @admin_role.update(instance_params)
        format.html { redirect_to @admin_role, success: I18n.t("#{singular_table_name}.success.update") }
        format.json { render :show, status: :ok, location: @admin_role }
      else
        format.html { render :edit }
        format.json { render json: @admin_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/roles/1
  # DELETE /admin/roles/1.json
  def destroy
    @admin_role.destroy

    respond_to do |format|
      format.html { redirect_to admin_roles_url, success: I18n.t("#{singular_table_name}.success.destroy") }
      format.json { head :no_content }
    end
  end

private

  def find_collection
    @admin_roles = policy_scope(Admin::Role)
  end

  def build_new_instance
    @admin_role = Admin::Role.new(instance_params)
  end

  def find_instance
    @admin_role = Admin::Role.find(params[:id])
  end

  def authorize_instance
    authorize @admin_role
  end

  def instance_params
    params.fetch(:admin_role, {})
  end
end
